# Utiliser une image Python officielle et légère comme base
FROM python:3.11-slim

# Définir des variables d'environnement pour les bonnes pratiques
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# --- DÉBUT DE LA MODIFICATION ---
# Installer les dépendances système nécessaires à la compilation
# gcc : compilateur C
# libc6-dev : Bibliothèque C standard (pour stdlib.h, etc.)
# libpq-dev : outils de développement pour PostgreSQL
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    libpq-dev
# --- FIN DE LA MODIFICATION ---

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le dossier complet des dépendances dans l'image
COPY ./requirements /app/requirements

# Installer les dépendances pour l'environnement local
RUN pip install --no-cache-dir -r /app/requirements/local.txt

# Copier tout le code de votre application dans le répertoire de travail du conteneur
COPY . .

# Exposer le port par défaut de l'application Django
EXPOSE 8000

# Commande par défaut pour lancer le serveur de développement.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
