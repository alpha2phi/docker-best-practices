FROM python:3.8-slim-buster AS builder

RUN pip install --upgrade pip
COPY ./requirements.txt /requirements.txt

# packages required for setting up WSGI
RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc libc-dev python3-dev

RUN pip install -r /requirements.txt

RUN mkdir /app
COPY . /app

RUN mkdir -p /static

RUN chmod -R 755 /static
RUN chmod -R 755 /app

# Production image
FROM gcr.io/distroless/python3-debian11

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/app:${PATH}"

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/
COPY --from=builder /app /app
COPY --from=builder /static /static

CMD ["entry_point.sh"]
