# -------------------------------
# Builder stage
# -------------------------------
FROM python:3.11-slim AS build

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir \
    --prefix=/install \
    -r requirements.txt

# -------------------------------
# Runtime stage (distroless)
# -------------------------------
FROM gcr.io/distroless/python3-debian11

# Make Python find copied site-packages
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages

WORKDIR /app

# Copy ONLY what is needed at runtime
COPY --from=build /install /usr/local

# 🔑 COPY THE APP CODE
COPY main.py /app/main.py

EXPOSE 8000

# Distroless already sets python as ENTRYPOINT
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8000"]

