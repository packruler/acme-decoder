FROM alpine:3.17

RUN apk --no-cache add jq

COPY --chown=root:root ./acme_decoder.sh /bin/acme-decode
RUN chmod 777 /bin/acme-decode

WORKDIR /data

ENTRYPOINT [ "/bin/acme-decode", "./acme.json" ]
