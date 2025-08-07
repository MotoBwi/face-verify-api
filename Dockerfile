FROM python:3.10-slim

# Install system dependencies for dlib and face_recognition
RUN apt-get update && apt-get install -y \
    build-essential cmake \
    libopenblas-dev liblapack-dev \
    libx11-dev libgtk-3-dev \
    libboost-all-dev python3-dev \
    git curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip
RUN pip install --upgrade pip

# Install Python packages (first numpy, then dlib, then face_recognition)
RUN pip install numpy
RUN pip install dlib==19.24.2
RUN pip install face_recognition==1.4.0

# Copy your app requirements
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy your app code
COPY ./app /app

# Run the FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
