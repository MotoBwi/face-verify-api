FROM python:3.10-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential cmake \
    libopenblas-dev liblapack-dev libx11-dev \
    libgtk-3-dev libboost-all-dev \
    python3-dev wget git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install pip dependencies
RUN pip install --upgrade pip
RUN pip install numpy
RUN pip install dlib
RUN pip install face_recognition

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY ./app /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
