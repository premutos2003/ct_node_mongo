FROM node

WORKDIR /usr/src/app
ARG port
COPY app /package*.json ./

RUN npm install

RUN apt-get update

COPY ./app .
EXPOSE $port

CMD npm start
