FROM python:3.10-slim

# System packages
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        cmake \
        libopenblas-dev \
        liblapack-dev \
        libx11-dev \
        libgtk-3-dev \
        libboost-all-dev \
        python3-dev \
        wget \
        git \
        curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Pre-install numpy (required for face_recognition)
RUN pip install --upgrade pip
RUN pip install numpy

# Install face_recognition and others
RUN pip install face_recognition

# Copy remaining files
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY ./app /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
