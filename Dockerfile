FROM python:3.10.2-alpine3.15

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY ./app /app

RUN pip install --no-cache-dir -r /app/requirements.txt


CMD [ "python", "./manage.py runserver 0.0.0.0:8000" ]
