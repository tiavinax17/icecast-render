# Utilise Ubuntu comme base
FROM ubuntu:22.04

# Empêche les prompts interactifs
ENV DEBIAN_FRONTEND=noninteractive

# Installe Icecast2
RUN apt-get update && \
    apt-get install -y icecast2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crée les dossiers nécessaires
RUN useradd -m -g icecast icecast || true && \
    mkdir -p /etc/icecast2 /var/log/icecast2 && \
    chown -R icecast:icecast /etc/icecast2 /var/log/icecast2

# Copie ton fichier de config
COPY icecast.xml /etc/icecast2/icecast.xml
RUN chown icecast:icecast /etc/icecast2/icecast.xml

# Le port sera fourni par Render
ENV PORT=10000
EXPOSE 10000

# Modifie le port dans le XML avant de démarrer
CMD sed -i "s|<port>8000</port>|<port>${PORT}</port>|" /etc/icecast2/icecast.xml && \
    echo 'Running Icecast on port' $PORT && \
    icecast2 -c /etc/icecast2/icecast.xml
