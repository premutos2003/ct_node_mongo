FROM node:alpine

ARG port
ARG folder=./app
ARG REACT_APP_PROD_API_URL=localhost

WORKDIR /usr/src/app

COPY ${folder} /package*.json ./

RUN npm install

COPY ./${folder} .
EXPOSE $port

CMD npm start