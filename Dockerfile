FROM ubuntu:18.04

COPY . /
RUN apt update -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install curl wget gnupg awscli git npm dnsutils unzip -y
RUN npm install n -g && \
    n stable && \
    PATH=$PATH
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -y && apt install yarn -y 

RUN mkdir /can-webhook
WORKDIR /can-webhook 
RUN wget https://canchain-testnet.s3-ap-southeast-1.amazonaws.com/containers-build/can-webhook-v1.1.1.zip && \
    unzip can-webhook-v1.1.1.zip && rm can-webhook-v1.1.1.zip && \
    yarn && \
    npm install -g pm2 && \
    yarn build 

EXPOSE 3000
CMD ["/can_webhook_start.sh"]