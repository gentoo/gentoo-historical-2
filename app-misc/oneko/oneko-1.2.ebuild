# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/app-misc/oneko/oneko-1.2.ebuild,v 1.3 2002/10/17 00:46:23 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A cat (or dog) which chases the mouse around the screen"
SRC_URI="http://agtoys.sourceforge.net/oneko/${P}.tar.gz"
HOMEPAGE="http://agtoys.sourceforge.net"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

DEPEND="x11-base/xfree"
RDEPEND="${DEPEND}"

src_compile() {
	xmkmf -a || die
	emake || die
}

src_install() {
	into /usr
	dobin oneko
	mv oneko._man oneko.1x
	doman oneko.1x
	dodoc oneko.1x.html oneko.1.html README README-NEW
}
