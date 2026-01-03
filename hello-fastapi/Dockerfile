# -------------------------------
# Builder stage
# -------------------------------
FROM python:3.11-slim AS builder

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install only what is required to build Python deps
COPY requirements.txt .

RUN pip install --no-cache-dir \
    --prefix=/install \
    -r requirements.txt

# -------------------------------
# Runtime stage (distroless)
# -------------------------------
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copy only installed Python packages
COPY --from=builder /install /usr/local

# Copy application code
COPY main.py /app/main.py

# Expose FastAPI port
EXPOSE 8000

# Distroless requires exec-form CMD
CMD ["-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

