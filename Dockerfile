FROM node:alpine

ARG entry

WORKDIR /usr/src/app
ARG port
COPY app /package*.json ./

RUN npm install

RUN npm install pm2 -g
COPY ./app .
EXPOSE $port

CMD entry
