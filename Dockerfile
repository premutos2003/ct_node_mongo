FROM mhart/alpine-node:latest

ARG entry
ENV my_env=$entry

RUN echo $entry
WORKDIR /usr/src/app
ARG port
COPY app /package*.json ./

RUN npm install

RUN npm install pm2 -g
COPY ./app .
EXPOSE $port

ENTRYPOINT $my_env
