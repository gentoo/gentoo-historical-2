# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/gwave/gwave-20031224.ebuild,v 1.4 2004/06/24 22:02:53 agriffis Exp $

DESCRIPTION="A waveform viewer analog data, such as SPICE simulations."
HOMEPAGE="http://www.geda.seul.org/tools/gwave/"
SRC_URI="http://www.geda.seul.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""
SLOT="0"

DEPEND=">=x11-libs/gtk+-1.2.10
	>=dev-util/guile-1.6.3
	>=x11-libs/guile-gtk-1.2.0.31"

src_compile() {

	econf || die
	make || die

}

src_install() {

	make DESTDIR=${D} install || die
	rm -f doc/Makefile* *.1
	dodoc AUTHORS INSTALL NEWS README TODO doc/*

}
