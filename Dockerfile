# Use the official image as a parent image.
FROM python:stretch

# Set the working directory.
COPY . /app
WORKDIR /app

# Run the command inside your image filesystem.
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Run the specified command within the container.
ENTRYPOINT [ "gunicorn", "-b", ":8080", "main:APP" ]
