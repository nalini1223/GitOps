# ---------- builder ----------
FROM python:3.11-slim AS build

WORKDIR /build
COPY requirements.txt .

# Force binary wheels only
RUN pip3.11 install --no-cache-dir \
    --only-binary=:all: \
    --target=/python \
    -r requirements.txt

# ---------- runtime ----------
FROM gcr.io/distroless/python3-debian12

ENV PYTHONPATH=/python
WORKDIR /app

COPY --from=build /python /python
COPY main.py /app/main.py

EXPOSE 8000
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8000"]
