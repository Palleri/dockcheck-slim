FROM alpine:latest
ARG TARGETPLATFORM
ENV NOTIFY="" \
NOTIFY_DEBUG="" \
NOTIFY_URLS=""
COPY app /app
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  os=amd64  ;; \
         "linux/arm64")  os=arm64  ;; \
    esac \
&& apk add --no-cache py-pip curl bash grep \
&& curl -L "https://download.docker.com/linux/static/stable/x86_64/docker-23.0.1.tgz" -o /app/docker.tgz \
&& curl -L "https://raw.githubusercontent.com/mag37/dockcheck/main/dockcheck.sh" -o /app/dockcheck.sh \
#&& curl -L "https://github.com/regclient/regclient/releases/download/v0.4.5/regctl-linux-amd64" -o /app/regctl \
&& curl -L "https://github.com/regclient/regclient/releases/download/v0.4.5/regctl-linux-${os}" -o /app/regctl \
&& pip install --no-cache-dir apprise \
&& chmod +x /app/run.sh
ENTRYPOINT ["/app/run.sh", "env"]