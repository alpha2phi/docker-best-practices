# Builder image
FROM python:3.8-slim-buster AS builder

RUN pip install --upgrade pip
COPY ./requirements.txt /requirements.txt

# packages required for setting up WSGI
RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc libc-dev python3-dev

RUN pip install -r /requirements.txt

RUN mkdir /app
COPY . /app


# Production image
FROM python:3.8.0-slim AS app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/app:${PATH}"

# folder to serve static file
RUN mkdir -p /static

WORKDIR /app

# always good to run our source code with a different user other than root user
RUN useradd appuser
RUN chown -R appuser:appuser /static

COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/
COPY --from=builder /app /app

# chmod 755 means full access to owner and read-access to everyone else
RUN chmod -R 755 /static
RUN chown -R appuser:appuser /app
RUN chmod -R 755 /app

# switch to our user
USER appuser

CMD ["entry_point.sh"]
