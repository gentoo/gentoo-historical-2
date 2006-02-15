# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jhead/jhead-2.5.ebuild,v 1.5 2006/02/15 14:13:17 gustavoz Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Exif Jpeg camera setting parser and thumbnail remover"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead/"
SRC_URI="http://www.sentex.net/~mwandel/jhead/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc-macos ~ppc64 sparc x86"
IUSE=""

DEPEND="virtual/libc"
RDEPEND="virtual/libc
	media-libs/jpeg"

src_unpack() {
	unpack ${A}; cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.5-gcc4.diff
	sed -i "s:-O3 -Wall:${CFLAGS}:" makefile || die "sed failed"
}

src_compile() {
	export CC="$(tc-getCC)"
	emake || die
}

src_install() {
	dobin jhead || die
	dodoc {readme,changes}.txt
	dohtml usage.html
	doman jhead.1.gz
}
