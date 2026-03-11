FROM python:3.11-slim

WORKDIR /app

# Copy requirements first — Docker caches this layer
# Only rebuilds if requirements.txt changes
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

# gunicorn is a production WSGI server
# never use Flask's built-in dev server in production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--timeout", "60", "app:app"]