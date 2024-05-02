# syntax = docker/dockerfile:1.0-experimental

FROM golang:1.22-alpine as BUILD

ENV GOOS "linux"
ENV GOVCS "*:all"
ENV CGO_ENABLED "0"

WORKDIR /

COPY . ./

RUN apk add --no-cache git

RUN go build --mod vendor --ldflags="-s -w -X 'main.VERSION=$(cat VERSION)'" -o /example-go-versioning

# --> Prevents shell access
RUN adduser -h "/dev/null" -g "" -s "/sbin/nologin" -D -H -u 10000 runtime

FROM scratch as RELEASE

WORKDIR /

COPY --from=BUILD /etc/passwd /etc/passwd
COPY --from=BUILD /example-go-versioning /usr/local/bin/example-go-versioning
COPY --from=BUILD /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

USER runtime

CMD ["example-go-versioning"]
