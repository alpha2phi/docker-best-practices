#!/bin/sh

set -e # exit if errors happen anywhere
python manage.py collectstatic --noinput
python manage.py migrate

gunicorn django_slim.asgi:application -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
