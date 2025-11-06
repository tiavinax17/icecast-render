# Étape 1 : Image de base
FROM ubuntu:22.04

# Étape 2 : Mise à jour + installation Icecast2 sans interface interactive
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y icecast2 mime-support && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Étape 3 : Crée un utilisateur non-root pour exécuter Icecast
RUN useradd -m -g icecast icecast || true && mkdir -p /etc/icecast2 && chown -R icecast:icecast /etc/icecast2

# Étape 4 : Copie ta configuration
COPY icecast.xml /etc/icecast2/icecast.xml
RUN chown icecast:icecast /etc/icecast2/icecast.xml

# Étape 5 : Définit le port exposé
EXPOSE 8000

# Étape 6 : Exécute Icecast avec l’utilisateur non-root
USER icecast
CMD ["icecast2", "-n", "-c", "/etc/icecast2/icecast.xml"]
