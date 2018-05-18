FROM node:alpine

WORKDIR /usr/src/app
ARG port
COPY app /package*.json ./

RUN npm install

COPY ./app .
EXPOSE $port

CMD npm start
