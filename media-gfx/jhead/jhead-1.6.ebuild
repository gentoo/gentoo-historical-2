# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jhead/jhead-1.6.ebuild,v 1.7 2003/10/05 21:03:59 todd Exp $

S=${WORKDIR}/${PN}1.6
DESCRIPTION="a program for making thumbnails for websites."
SRC_URI="http://www.sentex.net/~mwandel/jhead/${P}.tar.gz"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead/"

SLOT="0"
LICENSE="BSD | GPL-2"
KEYWORDS="x86 ~ppc ~sparc"

DEPEND="virtual/glibc"

src_compile() {

	cd ${S}
	emake || die
}

src_install () {

	dobin jhead
	dodoc readme.txt changes.txt
	dohtml usage.html
}
