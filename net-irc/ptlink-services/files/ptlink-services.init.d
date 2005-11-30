#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ptlink-services/files/ptlink-services.init.d,v 1.1.1.1 2005/11/30 09:48:56 chriswhite Exp $

depend() {
	need net
	use dns ircd
}

start() {
	ebegin "Starting ptlink-services"
	start-stop-daemon --start --quiet --exec /usr/bin/ptlink-services \
		--chuid ${PTLINKSERVICES_USER} >/dev/null
	eend $?
}

stop() {
	ebegin "Shutting down ptlink-services"
	start-stop-daemon --stop --exec /usr/bin/ptlink-services
	eend $?
}
