# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngcrush/pngcrush-1.6.19.ebuild,v 1.5 2010/01/07 20:06:15 ranger Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Portable Network Graphics (PNG) optimizing utility"
HOMEPAGE="http://pmt.sourceforge.net/pngcrush/"
SRC_URI="mirror://sourceforge/pmt/${P}-nolib.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/libpng-1.2.31"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-nolib"

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}"/Makefile "${S}" || die
}

src_compile() {
	tc-export CC
	emake || die "emake failed."
}

src_install() {
	dobin ${PN} || die "dobin failed."
	dohtml ChangeLog.html
}
