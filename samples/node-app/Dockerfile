FROM node:alpine
WORKDIR /app
ADD . .
RUN cd /app && npm install
EXPOSE 8081
CMD ["node", "/app/app"]
