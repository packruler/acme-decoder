FROM alpine:3.17

RUN apk --no-cache add jq

COPY --chown=root:root ./acme-exporter.sh /bin/acme-exporter
RUN chmod 777 /bin/acme-exporter

RUN mkdir /data

WORKDIR /data

CMD [ "/bin/acme-exporter", "./acme.json" ]
