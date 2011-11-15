#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/icinga/files/ido2db-init.d,v 1.1 2011/11/15 00:14:29 prometheanfire Exp $

IDO2DBBIN="/usr/sbin/ido2db"
SOCKET="/var/icinga/ido.sock"

function check() {
	if [ -S "${SOCKET}" ] ; then
		ewarn "Strange, the socket file already exist in \"${SOCKET}\""
		ewarn "it will be removed now and re-created by ido2db"
		ewarn "BUT please make your checks."
		rm -f "${SOCKET}"
	fi
}

depend() {
	need net
	use dns logger firewall
	after mysql postgresql
}

start() {
	check
	ebegin "Starting ido2db"
	start-stop-daemon --quiet --start --pidfile /var/icinga/ido2db.lock --startas ${IDO2DBBIN} -- -c ${IDO2DBCFG}
	eend $?
}

stop() {
	ebegin "Stopping ido2db"
	start-stop-daemon --quiet --stop --pidfile /var/icinga/ido2db.lock --name /usr/sbin/ido2db
	eend $?
}
