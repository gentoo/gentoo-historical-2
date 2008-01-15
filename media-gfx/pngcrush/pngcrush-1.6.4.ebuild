# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngcrush/pngcrush-1.6.4.ebuild,v 1.5 2008/01/15 18:18:15 grobian Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Portable Network Graphics (PNG) optimizing utility"
HOMEPAGE="http://pmt.sourceforge.net/pngcrush"
SRC_URI="mirror://sourceforge/pmt/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${PN}-1.6.2-ascall.patch
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="-I. ${CFLAGS}" || die "emake failed."
}

src_install() {
	dobin pngcrush
	dodoc *.txt
}
