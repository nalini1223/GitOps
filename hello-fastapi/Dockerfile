# syntax=docker/dockerfile:1

# Stage 1: Build stage
FROM python:3.11-slim AS build

# Set working directory
WORKDIR /app

# Copy requirement files first for caching
COPY requirements.txt .

# Install build dependencies
RUN pip install --upgrade pip \
    && pip install --user -r requirements.txt

# Copy application code
COPY . .

# Stage 2: Runtime stage using distroless
FROM gcr.io/distroless/python3-debian11

# Set working directory
WORKDIR /app

# Copy installed Python packages
COPY --from=build /root/.local /root/.local

# Copy application code
COPY --from=build /app /app

# Adjust PATH so Python packages installed with --user are found
ENV PATH=/root/.local/bin:$PATH

# Expose FastAPI default port
EXPOSE 8000

# Command to run the FastAPI app
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8000"]
