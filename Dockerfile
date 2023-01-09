FROM alpine:3.17

WORKDIR /data

COPY --chown=root:root ./acme-exporter.sh /bin/acme-exporter

RUN apk --no-cache add jq \
  && chmod 777 /bin/acme-exporter

CMD [ "/bin/acme-exporter", "./acme.json" ]
