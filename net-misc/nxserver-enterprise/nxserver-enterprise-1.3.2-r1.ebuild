# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxserver-enterprise/nxserver-enterprise-1.3.2-r1.ebuild,v 1.1 2004/08/30 15:45:49 stuart Exp $

inherit nxserver-1.3.2

DEPEND="$DEPEND
	!net-misc/nxserver-personal
	!net-misc/nxserver-business
	>=net-misc/nxproxy-1.3.0
	>=net-misc/nxclient-1.3.2"

MY_PV="${PV}-25"

SRC_URI="http://www.nomachine.com/download/nxserver-enterprise/${PV}/RedHat-9.0/nxserver-${MY_PV}.i386.rpm"
