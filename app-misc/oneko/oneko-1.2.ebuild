# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/oneko/oneko-1.2.ebuild,v 1.6 2003/08/06 07:56:27 vapier Exp $

DESCRIPTION="A cat (or dog) which chases the mouse around the screen"
HOMEPAGE="http://agtoys.sourceforge.net"
SRC_URI="http://agtoys.sourceforge.net/oneko/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"

DEPEND="x11-base/xfree"

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
