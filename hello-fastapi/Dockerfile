# ---------- builder ----------
# Slim Python image used only for dependency resolution.
# Build tooling is allowed here since this stage is not shipped.
FROM python:3.11-slim AS build

# Isolated build workspace to keep filesystem clean.
WORKDIR /build

# Copy dependencies first to maximize Docker layer caching.
COPY requirements.txt .

# Install dependencies into a custom path for distroless compatibility.
# Wheels only + no cache keeps layers small and deterministic.
RUN pip3.11 install \
    --no-cache-dir \
    --only-binary=:all: \
    --target=/python \
    -r requirements.txt

# Remove metadata not required at runtime to reduce image size.
RUN find /python -name "*.dist-info" -type d -exec rm -rf {} +

# ---------- runtime ----------
# Distroless runtime: Python + libc only (no shell, no package manager).
FROM gcr.io/distroless/python3-debian12 AS runtime

# Explicit dependency path required for distroless images.
ENV PYTHONPATH=/python

# Application runtime directory.
WORKDIR /app

# Copy only runtime dependencies from the builder stage.
COPY --from=build /python /python

# Copy minimal application entrypoint.
COPY app/main.py /app/main.py

# Document application port.
EXPOSE 8000

# Run via module execution to avoid PATH-based binaries.
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8000"]

