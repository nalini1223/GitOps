# -------------------------
# Builder Stage (Slim)
# -------------------------
FROM python:3.12-slim AS builder

WORKDIR /app

# Install deps into a clean prefix
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Copy application code
COPY app ./app

# -------------------------
# Runtime Stage (Distroless)
# -------------------------
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copy only what is required to run
COPY --from=builder /install /usr/local
COPY --from=builder /app /app

# Distroless runs as non-root by default
EXPOSE 8000

CMD ["-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
