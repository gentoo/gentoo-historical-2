#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/cherokee/files/cherokee-0.4.5-init.d,v 1.4 2004/07/15 00:25:54 agriffis Exp $

PIDFILE=/var/run/cherokee.pid

depend() {
	need net
}

start() {
	ebegin "Starting Cherokee Web Server"
	# make sure they can't break our startup by passing -d (which would
	# cause incorrect PID to be written to pidfile), or the incorrect
	# depot root
	start-stop-daemon --start --quiet \
		--pidfile ${PIDFILE} --make-pidfile -b \
		--exec /usr/bin/cherokee
	eend $?
}

stop() {
	ebegin "Stopping Cherokee Web Server"
	if [ -f ${PIDFILE} ]; then
		start-stop-daemon --stop --quiet --pidfile ${PIDFILE}
	fi
	rm -f ${PIDFILE}
	eend $?
}
