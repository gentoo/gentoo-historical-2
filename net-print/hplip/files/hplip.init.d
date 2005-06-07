#!/sbin/runscript
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-print/hplip/files/hplip.init.d,v 1.1 2005/06/07 17:02:33 lanius Exp $

depend() {
	before cupsd
	after hotplug
	use net
}

start() {
	ebegin "Starting hpiod"
	start-stop-daemon --start --quiet --exec /usr/sbin/hpiod
	eend $?

	ebegin "Starting hpssd"
	start-stop-daemon --quiet --start --exec /usr/share/hplip/hpssd.py \
		--pidfile /var/run/hpssd.pid >/dev/null 2>&1
	eend $?
}

stop() {
	ebegin "Stopping hpiod"
	start-stop-daemon --stop --quiet -n hpiod
	eend $?

	ebegin "Stopping hpssd"
	start-stop-daemon --stop --pidfile /var/run/hpssd.pid
	RETVAL=$?
	for PIDFILE in /var/run/*; do
		case "$( basename $PIDFILE )" in
			hpguid-*.pid)
				read PID < $PIDFILE
				kill $PID
				rm $PIDFILE
		esac
	done
	eend $RETVAL
}
