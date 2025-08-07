FROM python:3.10-slim

# System packages
RUN apt-get update && \
    apt-get install -y build-essential cmake \
    libopenblas-dev liblapack-dev libx11-dev \
    libgtk-3-dev libboost-all-dev \
    python3-dev wget git curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install pip packages
RUN pip install --upgrade pip

# ✅ Install dlib from wheel (no compile)
RUN pip install numpy
RUN pip install git+https://github.com/ageitgey/face_recognition

# Copy files
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY ./app /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
