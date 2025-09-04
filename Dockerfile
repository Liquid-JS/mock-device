FROM alpine:3.16.9

RUN apk add --no-cache --update \
    openssh-server openssh bash rsync && \
    rm -rf /var/cache/apk && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*

RUN mkdir /data
RUN chmod -R 755 /data
RUN chown -R root:root /data

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY sshd_config /etc/ssh/sshd_config

EXPOSE 922

ENTRYPOINT [ "/entrypoint.sh" ]
