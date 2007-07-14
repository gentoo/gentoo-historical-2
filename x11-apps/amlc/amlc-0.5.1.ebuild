# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/amlc/amlc-0.5.1.ebuild,v 1.3 2007/07/14 19:54:36 armin76 Exp $

inherit toolchain-funcs

DESCRIPTION="Another Modeline Calculator, generates quality X11 display configs easily."
HOMEPAGE="http://amlc.berlios.de"
SRC_URI="http://amlc.berlios.de/src/${P}.cpp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${P}.cpp "${S}"
}

src_compile() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${S}"/${P}.cpp -o amlc || die "build failed."
}

src_install() {
	dobin amlc
}
