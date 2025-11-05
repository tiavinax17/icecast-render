# Dockerfile pour Icecast
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y icecast2 && \
    apt-get clean

# Copie du fichier de configuration
COPY icecast.xml /etc/icecast2/icecast.xml

EXPOSE 8000

CMD ["icecast2", "-n", "-c", "/etc/icecast2/icecast.xml"]
