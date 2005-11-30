# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-im/aim-transport/files/aim-transport-conf.d,v 1.1.1.1 2005/11/30 10:09:29 chriswhite Exp $

CONFIG="/etc/jabber/aimtrans.xml"

#Need to find a way to fix the "double" expansion 
#PIDFILE= grep pid ${CONFIG} | sed -e 's/<[^>]*>//g' | sed s/' '//g
PIDFILE="/var/log/jabber/aim.pid"
