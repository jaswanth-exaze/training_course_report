FROM python:3.11-slim

# Set work directory inside container
WORKDIR /app

# Copy requirements and install
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy whole project (we mounted volume in compose too)
COPY . /app/backend

# Expose Flask port
EXPOSE 5000

# Run Flask app
CMD ["python", "backend/app.py"]
