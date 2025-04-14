FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV DJANGO_SETTINGS_MODULE=portfolio.settings
ENV PYTHONUNBUFFERED=1
WORKDIR /app/portfolio

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "portfolio.wsgi:application"]