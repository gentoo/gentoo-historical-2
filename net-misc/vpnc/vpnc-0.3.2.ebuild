# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vpnc/vpnc-0.3.2.ebuild,v 1.5 2005/05/08 02:37:03 pylon Exp $

inherit eutils

DESCRIPTION="Free client for Cisco VPN routing software"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~massar/vpnc/"
SRC_URI="http://www.unix-ag.uni-kl.de/~massar/vpnc/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=dev-libs/libgcrypt-1.1.91
	sys-apps/iproute2"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-64-bit.patch
	# Workaround for crappy Makefile
	sed -i -e "s:CFLAGS=-W -Wall -O:CFLAGS=${CFLAGS}:" Makefile
}

src_install() {
	dobin vpnc vpnc-connect vpnc-disconnect || die
	dodoc ChangeLog README TODO VERSION
	doman vpnc.8
	insinto /etc
	doins vpnc.conf
}
