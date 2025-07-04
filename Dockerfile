# Utiliser une image Python officielle et légère comme base
FROM python:3.11-slim

# Définir des variables d'environnement pour les bonnes pratiques
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    libpq-dev

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les dépendances et les installer
COPY ./requirements /app/requirements
RUN pip install --no-cache-dir -r /app/requirements/production.txt

# Copier tout le code de votre application dans le conteneur
COPY . .

# Lancer la commande pour collecter tous les fichiers statiques
RUN DJANGO_SECRET_KEY="dummy-key-for-build" \
    DATABASE_URL="postgres://dummy:dummy@db/dummy" \
    DJANGO_ADMIN_URL="/admin/" \
    DJANGO_SETTINGS_MODULE=config.settings.production \
    python manage.py collectstatic --no-input --clear

# Exposer le port que Gunicorn utilisera
EXPOSE 8000

# Lancer le serveur de production Gunicorn avec le bon chemin vers l'application WSGI
CMD ["gunicorn", "--workers", "3", "--timeout", "120", "--bind", "0.0.0.0:8000", "config.wsgi:application"]
