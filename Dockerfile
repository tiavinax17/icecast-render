# Étape 1 : Image de base
FROM ubuntu:22.04

# Étape 2 : Installation non interactive de Icecast2 + mime-support
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y icecast2 mime-support && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Étape 3 : Crée l'utilisateur non-root et attribue les permissions nécessaires
RUN useradd -m -g icecast icecast || true && \
    mkdir -p /etc/icecast2 && chown -R icecast:icecast /etc/icecast2 && \
    mkdir -p /var/log/icecast2 && chown -R icecast:icecast /var/log/icecast2

# Étape 4 : Copie ta configuration
COPY icecast.xml /etc/icecast2/icecast.xml
RUN chown icecast:icecast /etc/icecast2/icecast.xml

# Étape 5 : Port d'écoute
EXPOSE 8000

# Étape 6 : Lancer Icecast en utilisateur non-root
USER icecast
CMD ["icecast2", "-n", "-c", "/etc/icecast2/icecast.xml"]
