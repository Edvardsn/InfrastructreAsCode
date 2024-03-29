# Docker file inspired by the following:

# Agarwal, G. (2021) Modern DevOps Practices. 1st edn. Packt Publishing. 
# Available at: https://www.perlego.com/book/2931160/modern-devops-practices-pdf 

# https://docs.docker.com/language/python/containerize/


ARG PYTHON_VERSION=3.11.4
FROM python:${PYTHON_VERSION}-slim as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Create a non-privileged user that the app will run under.
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Download dependencies as a separate step to take advantage of Docker's caching.
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

# Switch to the non-privileged user to run the application.
USER appuser

# Copies everything in the project directory to the current directory in the container.
# In this case, everything in the project directory here will be copied into the root folder of the container.
COPY . .

RUN python3 app.test.py
# Exposes the port where the server will listen
EXPOSE 5000

# Run the application.
CMD ["python", "app.py"]
