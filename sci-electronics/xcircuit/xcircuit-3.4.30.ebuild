# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/xcircuit/xcircuit-3.4.30.ebuild,v 1.4 2009/09/27 14:50:34 nixnut Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="Circuit drawing and schematic capture program."
SRC_URI="http://opencircuitdesign.com/xcircuit/archive/${P}.tgz"
HOMEPAGE="http://opencircuitdesign.com/xcircuit"

KEYWORDS="amd64 ppc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="virtual/ghostscript
	dev-lang/tk
	x11-libs/libXt"
DEPEND="${RDEPEND}"

RESTRICT="test" #131024

src_prepare() {
	sed -i -e 's:$(datadir):$(libdir):g' Makefile.am || die "sed failed"
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--with-tcl \
		--with-ngspice
}

src_install () {
	emake DESTDIR="${D}" appdefaultsdir="/usr/share/X11/app-defaults" \
		appmandir="/usr/share/man/man1" install || die "emake install failed"
	dodoc CHANGES README* TODO
}
