# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gwave/gwave-20031224.ebuild,v 1.6 2007/01/10 17:45:04 hkbst Exp $

DESCRIPTION="A waveform viewer analog data, such as SPICE simulations."
LICENSE="GPL-2"
HOMEPAGE="http://www.geda.seul.org/tools/gwave/"
SRC_URI="http://www.geda.seul.org/dist/${P}.tar.gz"

KEYWORDS="~amd64 ppc x86"
IUSE=""
SLOT="0"

DEPEND=">=x11-libs/gtk+-1.2.10
	>=dev-scheme/guile-1.6.3
	>=x11-libs/guile-gtk-1.2.0.31"

src_compile() {
	econf || die "econf failed"
	make || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	rm -f doc/Makefile* *.1 || die "removing Makefile failed"
	dodoc AUTHORS INSTALL NEWS README TODO doc/* || die "dodoc failed"
}
