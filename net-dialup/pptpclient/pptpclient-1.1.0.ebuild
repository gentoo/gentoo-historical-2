# Copyright 2002 Gentoo Technologies Inc.
# Distributed under the terms of the GNU General Public License, v2.
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pptpclient/pptpclient-1.1.0.ebuild,v 1.2 2002/07/17 10:43:25 seemant Exp $


S=${WORKDIR}/pptp-linux-${PV}-1
DESCRIPTION="Linux client for the proprietary Microsoft Point-to-Point Tunneling Protocol, PPTP. Allows connection to a PPTP based VPN 
as used by employers and some cable and ADSL service providers."
HOMEPAGE="http://pptpclient.sourceforge.net"
SRC_URI="mirror://sourceforge/pptpclient/pptp-linux-${PV}-1.tar.gz"

DEPEND="net-dialup/ppp"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86"

src_compile() {
	cd ${S}
	tar zxf pptp-linux-${PV}.tar.gz
	cd ${S}/pptp-linux-${PV}

	make || die "make failed" 
}

src_install() {
	cd ${S}
	insinto /etc/ppp
	doins options.pptp
	dosbin pptp-command pptp_fe.pl xpptp_fe.pl	
	
	cd pptp-linux-${PV}
	dosbin pptp
	
	dodoc AUTHORS COPYING ChangeLog DEVELOPERS NEWS README TODO USING
	dodoc Documentation/*
	dodoc Reference/*
}

