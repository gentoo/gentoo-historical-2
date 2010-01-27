#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/tsm/files/dsmc.init.d,v 1.2 2010/01/27 16:47:11 dertobi123 Exp $

depend() {
        use net
        after dns
}

start() {
        ebegin "Starting dsmc"
        start-stop-daemon --start --background --nicelevel 15 \
                --make-pidfile --pidfile /var/run/dsmc.pid \
                --exec /opt/tivoli/tsm/client/ba/bin/dsmc sched ${DSMC_OPTS}
        eend $?
}

stop() {
        ebegin "Stopping dsmc"
        # For whatever reason SIGTERM doesn't affect the dsmc process, but
        # SIGHUP makes it exit cleanly
        start-stop-daemon --stop \
                --signal 1 \
                --pidfile /var/run/dsmc.pid
        eend $?
}

