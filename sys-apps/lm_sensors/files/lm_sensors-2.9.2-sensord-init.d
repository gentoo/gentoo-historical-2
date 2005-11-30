#!/sbin/runscript
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lm_sensors/files/lm_sensors-2.9.2-sensord-init.d,v 1.1.1.1 2005/11/30 09:57:08 chriswhite Exp $

CONFIG=/etc/sensors.conf

depend() {
	need logger
	use lm_sensors
}

checkconfig() {
	if [ ! -f ${CONFIG} ]; then
		eerror "Configuration file ${CONFIG} not found"
		return 1
	fi
}

start() {
	checkconfig || return 1

	ebegin "Starting sensord"
	start-stop-daemon --start --quiet --exec /usr/sbin/sensord \
		-- --config-file ${CONFIG} ${SENSORD_OPTIONS}
	eend ${?}
}

stop() {
	ebegin "Stopping sensord"
	start-stop-daemon --stop --quiet --pidfile /var/run/sensord.pid
	eend ${?}
}
