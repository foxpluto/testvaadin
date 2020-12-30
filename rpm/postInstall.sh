#!/bin/sh

set -e
APPUSER=vaadin
APPGROUP=vaadin
APPUID=3309
APPGID=3309
LOGDIR=/var/log/vaadin
DBDIR=/var/lib/vaadin

function reloadSystemd {
	which systemctl &>/dev/null
	if [[ $? -eq 0 ]]; then
		echo "Reloading systemd"
		systemctl daemon-reload
	fi
}

if grep -q $APPGID /etc/group
then
	echo "group $APPGID exists"
else
    	groupadd -g $APPGID $APPGROUP
    	echo "created group $APPGID"
fi

if id "$APPUSER" >/dev/null 2>&1; then
        echo "User $APPUSER already exists with uid $(id -u $APPUSER) gid $(id -g $APPUSER)"
else
        useradd -r -u $APPUID -g $APPGID -s /sbin/nologin $APPUSER
        echo "Created user $APPUSER with uid $(id -u $APPUSER) gid $(id -g $APPUSER)"
fi

echo "Creating log directory $LOGDIR"
mkdir -p $LOGDIR
chown $APPUSER:$APPUSER $LOGDIR

reloadSystemd

echo "Remember to configure /etc/vaadin/vaadin.cfg"