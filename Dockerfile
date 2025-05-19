FROM python:3.11

ENV PYTHONUNBUFFERED=1
ARG DEV=false

# Copier les fichiers requirements avant de les installer
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dec.txt /tmp/requirements.dec.txt

# Créer l'environnement virtuel et installer les dépendances
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dec.txt; fi && \
    rm -rf /tmp/requirements.txt /tmp/requirements.dec.txt && \
    adduser --disabled-password --no-create-home django-user

# Ajouter l'environnement virtuel au PATH
ENV PATH="/py/bin:$PATH"      

# Copier l'application après l'installation des dépendances
COPY ./app /app

WORKDIR /app

EXPOSE 8000

USER django-user
