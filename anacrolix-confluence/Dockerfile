FROM golang:bullseye as go-build
RUN go install github.com/anacrolix/confluence@latest
RUN cp $GOPATH/bin/confluence /usr/local/bin/

FROM debian:bullseye
ENTRYPOINT [ "/confluence" ]
CMD [ "-h" ]
COPY --from=go-build /usr/local/bin/confluence /confluence