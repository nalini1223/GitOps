# ---------- builder ----------
# Use a slim Python image ONLY for dependency resolution.
# This stage is allowed to have build tooling because it will not
# be part of the final runtime image.
FROM python:3.11-slim AS build

# All work in this stage happens in /build to keep paths explicit
# and avoid polluting the root filesystem.
WORKDIR /build

# Copy only requirements first to leverage Docker layer caching.
# If app code changes but requirements don't, pip install is reused.
COPY requirements.txt .

# Install Python dependencies into a custom directory (/python)
# instead of site-packages. This gives us full control over what
# gets copied into the final image.
#
# --only-binary=:all:
#   Forces pip to install prebuilt wheels only.
#   This avoids compiling native extensions, keeps the image smaller,
#   and prevents toolchain dependencies from leaking into runtime.
#
# --no-cache-dir:
#   Prevents pip from storing wheel caches, reducing layer size.
#
# --target=/python:
#   Installs all dependencies into /python instead of system paths,
#   which is critical for distroless compatibility.
RUN pip3.11 install --no-cache-dir \
    --only-binary=:all: \
    --target=/python \
    -r requirements.txt

# Remove *.dist-info directories.
# These contain metadata (licenses, RECORD files, etc.) that are not
# required at runtime and can add significant bloat.
# Safe to delete once dependencies are installed.
RUN find /python -name "*.dist-info" -type d -exec rm -rf {} +

# ---------- runtime ----------
# Use distroless Python for the final runtime.
# This image contains:
#   - Python interpreter
#   - glibc + CA certs
#   - NO shell, NO package manager, NO build tools
#
# This dramatically reduces attack surface and CVE exposure.
FROM gcr.io/distroless/python3-debian12 AS runtime

# Explicitly tell Python where to find third-party dependencies.
# Distroless does not use system site-packages, so this is required.
ENV PYTHONPATH=/python

# Set the working directory for the application.
# This ensures relative imports and module execution behave predictably.
WORKDIR /app

# Copy only the runtime dependencies from the builder stage.
# No build tools, no pip, no caches — just pure Python libraries.
COPY --from=build /python /python

# Copy only the application entrypoint.
# Keeping the runtime filesystem minimal improves security and clarity.
COPY app/main.py /app/main.py

# Expose the application port.
# This is documentation for humans and orchestration systems (Kubernetes).
EXPOSE 8000

# Run Uvicorn via Python module execution.
# Using `-m` avoids relying on PATH-based binaries,
# which may not exist in distroless images.
#
# "main:app" refers to:
#   - main.py (module)
#   - app (FastAPI application object)
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8000"]
