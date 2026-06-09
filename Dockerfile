FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /cpip-server ./cmd/server

FROM alpine:3.20
RUN adduser -D appuser
USER appuser
WORKDIR /home/appuser
COPY --from=builder /cpip-server /usr/local/bin/cpip-server

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/cpip-server"]
