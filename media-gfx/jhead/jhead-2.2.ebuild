# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jhead/jhead-2.2.ebuild,v 1.6 2005/09/13 17:02:48 agriffis Exp $

DESCRIPTION="Exif Jpeg camera setting parser and thumbnail remover"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead/"
SRC_URI="http://www.sentex.net/~mwandel/jhead/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~ppc ~ppc-macos ppc64 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A} ; cd ${S}

	sed -i "s:-O3 -Wall:${CFLAGS}:" makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin jhead || die
	dodoc readme.txt changes.txt
	dohtml usage.html
	doman jhead.1.gz
}
