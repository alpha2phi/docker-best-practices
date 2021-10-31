FROM python:3.8-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/app:${PATH}"

RUN pip install --upgrade pip
COPY ./requirements.txt /requirements.txt

# packages required for setting up WSGI
RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc libc-dev python3-dev

RUN pip install -r /requirements.txt

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN chmod +x *

# folder to serve media files by nginx
RUN mkdir -p /static/media

# folder to serve static files by nginx
RUN mkdir -p /static/files

# always good to run our source code with a different user other than root user
RUN useradd appuser
RUN chown -R appuser:appuser /static

# chmod 755 means full access to owner and read-access to everyone else
RUN chmod -R 755 /static
RUN chown -R appuser:appuser /app
RUN chmod -R 755 /app

# switch to our user
USER appuser

CMD ["entry_point.sh"]
