#!/sbin/runscript
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/hostapd/files/hostapd-0.5.0-init.d,v 1.2 2006/01/09 16:55:36 brix Exp $

opts="start stop reload"

depend() {
	local iface

	for iface in ${INTERFACES}; do
		need net.${iface}
	done

	use logger
}

checkconfig() {
	local file

	for file in ${CONFIGS}; do
		if [[ ! -r ${file} ]]; then
			eerror "hostapd configuration file (${CONFIG}) not found"
			return 1
		fi
	done
}

start() {
	checkconfig || return 1

	ebegin "Starting hostapd"
	start-stop-daemon --start --quiet --exec /usr/sbin/hostapd \
		-- ${OPTIONS} ${CONFIGS}
	eend ${?}
}

stop() {
	ebegin "Stopping hostapd"
	start-stop-daemon --stop --quiet --exec /usr/sbin/hostapd
	eend ${?}
}

reload() {
	checkconfig || return 1

	ebegin "Reloading hostapd configuration"
	kill -HUP $(pidof /usr/sbin/hostapd) > /dev/null 2>&1
	eend ${?}
}
