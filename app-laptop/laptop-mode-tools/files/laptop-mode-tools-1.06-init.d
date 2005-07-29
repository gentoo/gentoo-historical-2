#!/sbin/runscript
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/laptop-mode-tools/files/laptop-mode-tools-1.06-init.d,v 1.1 2005/07/29 09:24:33 brix Exp $

checkconfig() {
    if [ ! -f /proc/sys/vm/laptop_mode ]; then
		eerror "Kernel does not support laptop_mode"
		return 1
    fi
}

start() {
    checkconfig || return 1

    ebegin "Starting laptop_mode"
    touch /var/run/laptop-mode-enabled && /usr/sbin/laptop_mode auto &> /dev/null
    eend $?
}

stop() {
    ebegin "Stopping laptop_mode"
    /usr/sbin/laptop_mode stop &> /dev/null && rm -f /var/run/laptop-mode-enabled
    eend $?
}
