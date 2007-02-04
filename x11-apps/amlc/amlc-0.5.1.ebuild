# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/amlc/amlc-0.5.1.ebuild,v 1.1 2007/02/04 10:22:27 drac Exp $

inherit toolchain-funcs

DESCRIPTION="Another Modeline Calculator. Generates quality X11 display configs easily."
HOMEPAGE="http://amlc.berlios.de/"
SRC_URI="http://amlc.berlios.de/src/${P}.cpp"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${P}.cpp "${S}"
}

src_compile() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${S}"/${P}.cpp -o amlc || die "compile failed"
}

src_install() {
	dobin amlc || die "install failed"
}
