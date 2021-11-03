FROM python:3.9-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/app:${PATH}"

RUN apk add --no-cache --virtual .build-deps gcc musl-dev 

RUN pip install --upgrade pip
COPY ./requirements.txt /requirements.txt

RUN pip install -r /requirements.txt

RUN mkdir /app
COPY . /app
WORKDIR /app

# folder to serve static file
RUN mkdir -p /static

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
