#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/firebird/files/firebird.init.d,v 1.2 2004/07/14 21:38:45 agriffis Exp $

 
#  NOTE: make sure you have localhost in your hosts.equiv file see next 2 
#  lines for example of hosts.equiv contents
#localhost.localdomain
#localhost


export FIREBIRD
export ISC_USER
export ISC_PASSWORD
export FBRunUser
MANAGER=$FIREBIRD/bin/fbmgr.bin

depend() {
	need net
}

start(){
	ebegin "Starting Firebird server"
	su $FBRunUser -c "${MANAGER} -start -forever"
	eend $?
}

stop(){
	ebegin "Stopping Firebird server"
	$MANAGER -shut
	eend $?
}
