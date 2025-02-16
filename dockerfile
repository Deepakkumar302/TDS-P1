# Use a lightweight Python base image
FROM python:3.12-slim-bookworm

# Set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download and install uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure `uv` is available in the PATH
ENV PATH="/root/.local/bin:$PATH"

# Install FastAPI and Uvicorn using uv
RUN /root/.local/bin/uv venv && /root/.local/bin/uv pip install fastapi uvicorn

# Copy application files
COPY app.py .

# Expose the FastAPI port
EXPOSE 8000

# Run the application
CMD ["/root/.local/bin/uv", "run", "app.py"]
