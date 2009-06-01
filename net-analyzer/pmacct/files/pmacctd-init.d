#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/pmacct/files/pmacctd-init.d,v 1.4 2009/06/01 09:48:41 pva Exp $

depend() {
	need net
}

checkconfig() {
	if [ ! -e /etc/pmacctd.conf ] ; then
		eerror "You need an /etc/pmacctd.conf file to run pmacctd"
		return 1
	fi
}

start() {
	checkconfig || return 1
	ebegin "Starting pmacctd"
	start-stop-daemon --start --pidfile /var/run/pmacctd.pid --exec /usr/sbin/pmacctd \
		-- -D -f /etc/pmacctd.conf -F /var/run/pmacctd.pid ${OPTS}
	eend $?
}

stop() {
	ebegin "Stopping pmacctd"
	start-stop-daemon --stop --pidfile /var/run/pmacctd.pid --exec /usr/sbin/pmacctd
	eend $?
}
