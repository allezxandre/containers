FROM golang:bullseye as go-build
RUN go install github.com/anacrolix/confluence@latest
RUN cp $GOPATH/bin/confluence /usr/local/bin/

FROM debian:bullseye

# These labels will be overridden by GitHub Actions
LABEL org.opencontainers.image.title="anacrolix-confluence"
LABEL org.opencontainers.image.description="Debian Bullseye with anacrolix/confluence"
LABEL org.opencontainers.image.authors="alexandre@jouandin.eu"

ENTRYPOINT [ "/confluence" ]
CMD [ "-h" ]
COPY --from=go-build /usr/local/bin/confluence /confluence