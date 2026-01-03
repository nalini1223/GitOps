# Python
# Import FastAPI
from fastapi import FastAPI

# Create FastAPI instance
app = FastAPI()

# Define a root endpoint that returns "Hello World"
@app.get("/")
def read_root():
    return {"message": "Hello World"}

#health endpoint 
@app.get("/health")
def health():
    return {"status": "ok"}

# To run the application locally:
# uvicorn main:app --reload
# 'main' is the filename (main.py) and 'app' is the FastAPI instance.

