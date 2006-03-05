# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/fping/fping-2.4_beta2.ebuild,v 1.13 2006/03/05 20:21:51 jokey Exp $

S=${WORKDIR}/fping-2.4b2_to-ipv6
DESCRIPTION="A utility to ping multiple hosts at once"
SRC_URI="http://www.fping.com/download/fping-2.4b2_to-ipv6.tar.gz"
HOMEPAGE="http://www.fping.com/"

SLOT="0"
LICENSE="fping"
KEYWORDS="x86 sparc ppc-macos"
IUSE=""

src_compile() {

	econf || die
	make || die
}

src_install () {

	dosbin fping
	doman fping.8
	dodoc ChangeLog README
}
