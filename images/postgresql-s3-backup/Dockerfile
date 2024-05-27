FROM ubuntu:22.04

WORKDIR /dump

RUN apt update \
    && ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
    && apt-get install -y tzdata gnupg wget curl unzip ca-certificates postgresql-common \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
    && apt update \
    && apt install -y postgresql-client-15 \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws \
    && aws --version

CMD ["bash"]
