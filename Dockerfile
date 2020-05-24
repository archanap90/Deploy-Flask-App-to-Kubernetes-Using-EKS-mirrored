# Use the official image as a parent image.
FROM python:stretch

# Set the working directory.
WORKDIR /usr/src/app

# Copy the file from your host to your current location.
COPY requirements.txt .

# Run the command inside your image filesystem.
RUN pip install -r requirements.txt

ENV JWT_SECRET $JWT_SECRET
ENV LOG_LEVEL $LOG_LEVEL

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

# Run the specified command within the container.
ENTRYPOINT [ "gunicorn", "-b", ":8080", "main:APP" ]

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .