# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngcrush/pngcrush-1.7.6.ebuild,v 1.2 2010/01/07 22:08:33 fauli Exp $

EAPI="2"

inherit toolchain-funcs

MY_P="${P}-nolib"

DESCRIPTION="Portable Network Graphics (PNG) optimizing utility"
HOMEPAGE="http://pmt.sourceforge.net/pngcrush/"
SRC_URI="mirror://sourceforge/pmt/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="media-libs/libpng
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cp "${FILESDIR}/Makefile" "${S}" || die
	tc-export CC
}

src_install() {
	dobin ${PN} || die "dobin failed."
	dohtml ChangeLog.html || die
}
