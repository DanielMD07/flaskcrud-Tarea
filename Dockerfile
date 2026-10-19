FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# mysqlclient (Flask-MySQLdb) necesita compilador y las librerias de cliente de MySQL
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        pkg-config \
        default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /code

# Primero las dependencias, para aprovechar la cache de Docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# main.py hace "from app import app", asi que el contenido de la carpeta app/
# debe quedar en la raiz de /code (junto a app.py, db.py, contacts.py, templates/ y static/)
COPY app/ .

EXPOSE 8080

CMD ["python", "main.py"]
