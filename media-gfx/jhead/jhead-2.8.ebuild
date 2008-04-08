# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jhead/jhead-2.8.ebuild,v 1.7 2008/04/08 09:12:40 armin76 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Exif Jpeg camera setting parser and thumbnail remover"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead/"
SRC_URI="http://www.sentex.net/~mwandel/jhead/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ppc64 sparc x86"
IUSE=""

RDEPEND="media-libs/jpeg"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	sed -i -e "s:-O3 -Wall:${CFLAGS}:" "${S}"/makefile || die "sed failed."
}

src_compile() {
	tc-export CC
	emake || die "emake failed."
}

src_install() {
	dobin jhead || die "dobin failed."
	dodoc {readme,changes}.txt
	dohtml usage.html
	doman jhead.1.gz
}
