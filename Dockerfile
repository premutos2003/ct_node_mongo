FROM mhart/alpine-node:latest

ARG entry
ENV my_env=$entry

RUN echo $entry
WORKDIR /usr/src/app
ARG port
COPY app /package*.json ./

RUN npm install ---no-audit

RUN npm install pm2 -g --no-audit
COPY ./app .

RUN ls

EXPOSE $port
CMD $my_env










