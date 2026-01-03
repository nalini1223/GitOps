# -------------------------
# Builder stage
# -------------------------
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

# Install deps into a known runtime path
RUN pip install --no-cache-dir --target=/app/deps -r requirements.txt

COPY app ./app

# -------------------------
# Runtime stage (distroless)
# -------------------------
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copy dependencies and app code
COPY --from=builder /app/deps /app/deps
COPY --from=builder /app/app /app/app

# Tell Python where to find deps
ENV PYTHONPATH=/app/deps

EXPOSE 8000

CMD ["-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
