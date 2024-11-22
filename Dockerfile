FROM python:latest

# Copy your application files
COPY . .

# Install required dependencies
RUN pip3 install -r "requirements.txt"

# Install Gunicorn
RUN pip3 install gunicorn

# Expose a different port to avoid conflicts with Jenkins
EXPOSE 8081

# Start the app using Gunicorn
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8081", "lbg:app"]

