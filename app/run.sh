#!/bin/sh
echo "# Starting Dockcheck-web #"
echo "# Checking for new updates #"
echo "# This might take a while, it depends on how many containers are running #"

cd /app && tar xzvf /app/docker.tgz > /dev/null 2>&1 && cp /app/docker/* /usr/bin/ > /dev/null 2>&1



if [ "$NOTIFY" = "true" ]; then
    if [ -n "$NOTIFY_URLS" ]; then
        echo $NOTIFY_URLS > /app/NOTIFY_URLS
        echo "Notify activated"
    fi

    if [ -n "$EXCLUDE" ]; then
    echo $EXCLUDE > /app/EXCLUDE
    fi

    if [ "$NOTIFY_DEBUG" = "true" ]; then
        echo $NOTIFY_DEBUG > /app/NOTIFY_DEBUG
        echo "NOTIFY DEBUGMODE ACTIVATED"  
    fi
fi



chmod +x /app/dockcheck.sh
cp  /app/root /etc/crontabs/root
cp /app/dockcheck /etc/periodic/daily/dockcheck
chmod +x /app/regctl
chmod +x /etc/periodic/daily/dockcheck
cp /app/regctl /usr/bin/

/etc/periodic/daily/dockcheck

exec crond -f