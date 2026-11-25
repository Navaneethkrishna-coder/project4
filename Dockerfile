
FROM python:3.9-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY project4/ .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "project4.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2"]
