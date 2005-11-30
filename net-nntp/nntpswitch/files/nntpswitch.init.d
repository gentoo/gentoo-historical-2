#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-nntp/nntpswitch/files/nntpswitch.init.d,v 1.1.1.1 2005/11/30 10:02:45 chriswhite Exp $

depend() {
	use net
}

start() {
	ebegin "Starting NNTP Switch"
	/usr/sbin/nntpswitchd &>/dev/null
	eend $?
}

stop() {
	ebegin "Stopping NNTP Switch"
	start-stop-daemon --stop --quiet --pidfile /var/run/nntpswitchd.pid
	eend $?
	rm -f /var/run/nntpswitchd.pid
}
