#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2         
# $Header: /var/cvsroot/gentoo-x86/media-sound/daapd/files/daapd.init.d,v 1.4 2005/01/30 01:19:05 luckyduck Exp $

depend() {
	need net
	use mDNSResponder
}

checkconfig() {
	grep '^Root		\.$' /etc/daapd.conf &>/dev/null && \
		ewarn "The Root in /etc/daapd.conf has not been updated. You probably" && \
		ewarn "want to point this to your music archive instead of" `pwd`
}

start() {
	ebegin "Starting daapd"
	checkconfig

	local SSD_OPTS
	SSD_OPTS=""
	[ "${DAAPD_RUNAS}"x != ""x ] && SSD_OPTS="${SSD_OPTS} --chuid '${DAAPD_RUNAS}'"

	start-stop-daemon --start --quiet --pidfile /var/run/daapd.pid \
		--background --make-pidfile \
		${SSD_OPTS} --startas /usr/bin/daapd -- ${DAAPD_OPTS}
	eend $? "Failed to start daapd"
}

stop() {
	ebegin "Stopping daapd"
	start-stop-daemon --stop --quiet --pidfile /var/run/daapd.pid
	eend $? "Failed to stop daapd"

	# clean stale pidfile
	[ -f /var/run/daapd.pid ] && rm -f /var/run/daapd.pid
}
