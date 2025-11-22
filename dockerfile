FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python2.7 \
    openjdk-8-jdk \
    curl \
    openssl \
    wget \
    nodejs \
    npm

# Oude npm packages met CVEs
RUN npm install -g express@3.0.0 || true
