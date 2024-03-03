FROM ubuntu:latest

ENV DEBIAN_FRONTEND = noninteractive

RUN apt-get update && \
    apt-get install -y dumb-init curl awscli mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 -o /usr/local/bin/supercronic && \
    chmod +x /usr/local/bin/supercronic

ENV MYSQLDUMP_OPTIONS --quick --no-create-db --add-drop-table --add-locks --allow-keywords --quote-names --disable-keys --single-transaction --create-options --comments --net_buffer_length=16384
ENV MYSQLDUMP_DATABASE **None**
ENV MYSQL_HOST **None**
ENV MYSQL_PORT 3306
ENV MYSQL_USER **None**
ENV MYSQL_PASSWORD **None**
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV S3_PREFIX 'mysql-backup'
ENV S3_FILENAME **None**
ENV MULTI_DATABASES no
ENV SCHEDULE **None**

ADD entrypoint.sh backup.sh /

HEALTHCHECK CMD curl --fail http://localhost:9746/health || exit 1

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["sh", "/entrypoint.sh"]
