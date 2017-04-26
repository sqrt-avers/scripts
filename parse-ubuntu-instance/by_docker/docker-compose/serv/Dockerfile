FROM node:latest
RUN apt-get update
RUN apt-get install -y git curl build-essential python-software-properties
WORKDIR /opt
RUN git clone https://github.com/ParsePlatform/parse-server-example.git
ADD index.js /opt/parse-server-example
WORKDIR /opt/parse-server-example
RUN npm install
CMD [ "npm","start","index.js" ]
