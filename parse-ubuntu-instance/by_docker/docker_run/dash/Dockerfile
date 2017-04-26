FROM node:latest
RUN apt-get update
RUN npm install -g parse-dashboard
ADD parse-dashboard-config.json /
CMD [ "parse-dashboard","--config","/parse-dashboard-config.json","--allowInsecureHTTP=1" ]
