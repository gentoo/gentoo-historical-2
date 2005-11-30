# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-im/jabberd/files/jabber-conf.d,v 1.1.1.1 2005/11/30 10:09:44 chriswhite Exp $

# Configure which is the default jabberd server. Any value that is not
# jabberd14 and jabberd2 will be started

JABBERD="jabberd14"

#Right now this is only used by the init script, but i would like to find a way
#for jabberd to include this in the conf
JPIDFILE="/var/log/jabber/jabberd14.pid"
