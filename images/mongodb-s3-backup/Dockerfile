FROM ubuntu:22.04

WORKDIR /dump

RUN apt update \
    && ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
    && apt-get install -y tzdata gnupg wget curl unzip \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | tee /etc/apt/trusted.gpg.d/server-7.0.asc \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list \
    && apt update \
    && apt-get install -y mongodb-mongosh mongodb-database-tools \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws \
    && aws --version

CMD ["bash"]
