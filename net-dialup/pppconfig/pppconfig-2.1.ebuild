# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pppconfig/pppconfig-2.1.ebuild,v 1.3 2003/10/27 09:54:31 aliz Exp $

DESCRIPTION="A text menu based utility for configuring ppp."
SRC_URI="mirror://debian/pool/main/p/pppconfig/${PN}_${PV}.tar.gz"
HOMEPAGE="http://ftp.debian.org/debian/pool/main/p/pppconfig/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"


DEPEND=">=net-dialup/ppp-2.4.1-r2
		 >=dev-util/dialog-0.7"


src_install () {
	 dodir /etc/chatscripts
	 dodir /etc/ppp/resolv
	 dosbin 0dns-down 0dns-up dns-clean
	 newsbin pppconfig pppconfig.real
	 dosbin ${FILESDIR}/pppconfig
	 doman pppconfig.8
	 dodoc debian/{copyright,README.debian,changelog}
}

