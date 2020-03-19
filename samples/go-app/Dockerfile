FROM golang:alpine as builder
WORKDIR /main
RUN apk add --no-cache git
COPY . /main
RUN CGO_ENABLED=0 GOOS=linux go build 

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /main /main
EXPOSE 8080
WORKDIR /main
CMD ["./main"]
