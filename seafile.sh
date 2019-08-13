#!/bin/bash

log=/var/log/seafile.log

function stop_server() {
    /opt/seafile/seafile-server-latest/seafile.sh stop >> $log 2>&1
    exit 0
}

trap stop_server SIGINT SIGTERM

[[ "${autostart}" =~ ^[Tt]rue && -x /opt/seafile/seafile-server-latest/seafile.sh ]] || exit 0

# Fix for https://github.com/haiwen/seafile/issues/478, forward seafdav localhost-only port
[[ "${workaround478}" =~ [Tt]rue ]] && socat TCP4-LISTEN:8080,fork TCP4:localhost:8081 &

/opt/seafile/seafile-server-latest/seafile.sh start >> $log 2>&1

# Script should not exit unless seafile died
while pgrep -f "seafile-controller" 2>&1 >/dev/null; do
    sleep 5;
done

exit 0
