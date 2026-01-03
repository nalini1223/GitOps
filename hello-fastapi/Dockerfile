# -------------------------
# Builder
# -------------------------
FROM python:3.12-slim AS builder

WORKDIR /build

COPY requirements.txt .

RUN pip install \
    --no-cache-dir \
    --target=/build/deps \
    -r requirements.txt

COPY app /build/app

# -------------------------
# Runtime (DISTROLESS)
# -------------------------
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

COPY --from=builder /build/deps /app/deps
COPY --from=builder /build/app /app/app

ENV PYTHONPATH=/app/deps

EXPOSE 8000

CMD ["-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

