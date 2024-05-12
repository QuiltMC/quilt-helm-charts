FROM ubuntu:22.04

WORKDIR /dump

RUN apt update \
    && ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
    && apt-get install -y tzdata postgresql-client curl unzip \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws \
    && aws --version

CMD ["bash"]
