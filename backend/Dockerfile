# FROM python:3.10-slim

# WORKDIR /app

# # Install dependencies first (layer cache)
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy source code
# COPY . ./backend/

# # pokieticker.db and backend/ml/models/ are mounted at runtime via volumes

# EXPOSE 8000

# RUN addgroup --system app && adduser --system --ingroup app app

# USER app

# CMD ["uvicorn", "backend.api.main:app", "--host", "0.0.0.0", "--port", "8000"]







FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create runtime user
RUN addgroup --system app && \
    adduser --system --ingroup app app

# Copy application
COPY . ./backend/

# Create writable data directory and fix ownership
RUN mkdir -p /data && \
    chown -R app:app /app /data

USER app

EXPOSE 8000

CMD ["uvicorn", "backend.api.main:app", "--host", "0.0.0.0", "--port", "8000"]