FROM node:alpine
WORKDIR /app
ADD package.json /app
RUN cd /app && npm install
ADD app.js /app
EXPOSE 8081
CMD ["node", "/app/app"]
