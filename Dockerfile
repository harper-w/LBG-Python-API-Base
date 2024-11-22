FROM python:latest

# Copy your application files
COPY . .

# Install required dependencies
RUN pip3 install -r "requirements.txt"

# Install Gunicorn
RUN pip3 install gunicorn

# Expose a different port to avoid conflicts with Jenkins
EXPOSE 8081

# Create an entrypoint
ENTRYPOINT [ "python", "app.py" ]

