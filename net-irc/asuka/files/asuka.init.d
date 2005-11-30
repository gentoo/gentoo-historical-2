#!/sbin/runscript
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/asuka/files/asuka.init.d,v 1.1.1.1 2005/11/30 09:49:01 chriswhite Exp $

depend() {
	need net
}

start() {
	ebegin "Starting asuka-ircd"
	start-stop-daemon --start --quiet --chuid ${ASUKA_UID} --exec /usr/bin/asuka-ircd
	eend $? "Failed to start asuka-ircd"
}

stop() {
	ebegin "Stopping asuka-ircd"
	start-stop-daemon --stop --quiet --exec /usr/bin/asuka-ircd
	eend $? "Failed to stop asuka-ircd"
}
