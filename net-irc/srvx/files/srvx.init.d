#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/srvx/files/srvx.init.d,v 1.1.1.1 2005/11/30 09:48:57 chriswhite Exp $

depend() {
	use dns net
}

start() {
	ebegin "Starting srvx"
	start-stop-daemon --start --chdir /var/lib/srvx --quiet \
		--exec /usr/bin/srvx --chuid ${SRVX_USER}:${SRVX_GROUP} &>/dev/null
	eend $?
}

stop() {
	ebegin "Shutting down srvx"
	start-stop-daemon --stop --quiet --pidfile /var/lib/srvx/srvx.pid
	eend $?
}
