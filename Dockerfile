FROM golang:latest

ARG JUNO_WORKERS_NUMBER=1

ENV JUNO_WORKERS_NUMBER=${JUNO_WORKERS_NUMBER}

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build

CMD ./juno docker.config.toml --workers $JUNO_WORKERS_NUMBER
