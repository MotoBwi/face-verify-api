FROM python:3.10-slim

# System-level dependencies
RUN apt-get update && \
    apt-get install -y build-essential cmake \
    libopenblas-dev liblapack-dev libx11-dev \
    libgtk-3-dev libboost-all-dev \
    python3-dev wget git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Install Python packages manually
RUN pip install --upgrade pip

# Manually install face_recognition with all dependencies
RUN pip install numpy
RUN pip install dlib
RUN pip install face_recognition

# Other Python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy app code
COPY ./app /app

# Run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
