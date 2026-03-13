import os
import json
import boto3
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)


# ─── Fetch DB credentials from Secrets Manager ──────────────
# The EC2 IAM role grants permission to read this secret
# Credentials are never hardcoded or stored in environment files
def get_db_credentials():
    client = boto3.client("secretsmanager", region_name=os.environ["AWS_REGION"])
    response = client.get_secret_value(SecretId=os.environ["SECRET_NAME"])
    return json.loads(response["SecretString"])


creds = get_db_credentials()
db_host = os.environ.get("DB_HOST", "localhost")

app.config["SQLALCHEMY_DATABASE_URI"] = (
    f"postgresql://{creds['username']}:{creds['password']}"
    f"@{db_host}/{creds['dbname']}"
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)


# ─── Model ───────────────────────────────────────────────────
class Task(db.Model):
    __tablename__ = "tasks"
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    completed = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now())

    def to_dict(self):
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "completed": self.completed,
            "created_at": str(self.created_at),
        }


# ─── Routes ──────────────────────────────────────────────────
@app.route("/health")
def health():
    # ALB calls this every 30 seconds
    # Must return 200 or ALB marks this instance unhealthy
    try:
        db.session.execute(db.text("SELECT 1"))
        return jsonify({"status": "healthy", "db": "connected", "version": "2.0"}), 200
    except Exception as e:
        return jsonify({"status": "unhealthy", "error": str(e)}), 500

;
@app.route("/tasks", methods=["GET"])
def get_tasks():
    tasks = Task.query.order_by(Task.created_at.desc()).all()
    return jsonify([t.to_dict() for t in tasks])


@app.route("/tasks", methods=["POST"])
def create_task():
    data = request.get_json()
    task = Task(title=data["title"], description=data.get("description", ""))
    db.session.add(task)
    db.session.commit()
    return jsonify(task.to_dict()), 201


@app.route("/tasks/<int:task_id>", methods=["PUT"])
def update_task(task_id):
    task = Task.query.get_or_404(task_id)
    data = request.get_json()
    if "completed" in data:
        task.completed = data["completed"]
    if "title" in data:
        task.title = data["title"]
    db.session.commit()
    return jsonify(task.to_dict())


@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    task = Task.query.get_or_404(task_id)
    db.session.delete(task)
    db.session.commit()
    return jsonify({"deleted": task_id}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
