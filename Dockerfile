FROM alpine:latest
ARG TARGETPLATFORM
ENV NOTIFY="" \
NOTIFY_DEBUG="" \
NOTIFY_URLS="" \
EXCLUDE="" \
CRON_TIME=""
COPY app /app
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  os=amd64  ;; \
         "linux/arm64")  os=arm64  ;; \
    esac \
&& case ${TARGETPLATFORM} in \
         "linux/amd64")  dockeros=x86_64  ;; \
         "linux/arm64")  dockeros=aarch64  ;; \
    esac \
&& apk add --no-cache py-pip curl bash grep \
&& curl -L "https://download.docker.com/linux/static/stable/${dockeros}/docker-23.0.1.tgz" -o /app/docker.tgz \
&& curl -L "https://raw.githubusercontent.com/mag37/dockcheck/main/dc_brief.sh" -o /app/dockcheck.sh \
#&& curl -L "https://github.com/regclient/regclient/releases/download/v0.4.5/regctl-linux-amd64" -o /app/regctl \
&& curl -L "https://github.com/regclient/regclient/releases/download/v0.4.5/regctl-linux-${os}" -o /app/regctl \
&& pip install --no-cache-dir apprise \
&& chmod +x /app/run.sh
ENTRYPOINT ["/app/run.sh", "env"]