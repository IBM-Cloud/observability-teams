FROM node:alpine
WORKDIR /app
ADD . .
RUN cd /app && npm install
EXPOSE 80
CMD ["node", "/app/app"]
