FROM ubuntu:latest

RUN apt-get update -y
RUN apt install openjdk-21-jre jq curl -y

RUN rm -rf /var/lib/apt/lists/*

ENV VERSION=latest
ENV BUILD=latest
ENV EULA=false


COPY ./script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh


VOLUME ["/data"]

WORKDIR /data


ENTRYPOINT ["/usr/local//bin/script.sh"]
 