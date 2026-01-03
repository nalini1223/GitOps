from fastapi import FastAPI
from fastapi.responses import JSONResponse

# Create an instance of FastAPI
app = FastAPI(title="My API Example")

# Root endpoint (fixes 404 on /)
@app.get("/")
async def root():
    return {"message": "Welcome to My API"}

@app.get("/items")
async def read_items():
    return {"message": "Hello World"}

# Define the /health endpoint
@app.get("/health", response_class=JSONResponse)
async def health_check():
    # Return a simple JSON response indicating health status
    return {"status": "ok"}

# Example of running the app using uvicorn
# To run the app, save this file as main.py and then run:
# uvicorn main:app --reload
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000, reload=True)
