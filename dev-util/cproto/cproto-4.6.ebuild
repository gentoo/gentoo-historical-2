# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cproto/cproto-4.6.ebuild,v 1.3 2003/02/13 11:48:28 vapier Exp $

IUSE=""

S="${WORKDIR}/${P}"
DESCRIPTION="generate C function prototypes from C source code"
SRC_URI="http://dl.sourceforge.net/sourceforge/cproto/cproto-4.6.tar.gz"
HOMEPAGE="http://cproto.sourceforge.net/"

SLOT="0"
KEYWORDS="x86"
LICENSE="public-domain"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}

	patch -p1 < ${FILESDIR}/${P}-mkstemp.patch
}

src_compile() {
	econf || die "./configure failed"
	emake
}

src_install() {

	dodir /usr/bin
	dobin cproto
	doman cproto.1
	dodoc README CHANGES
}
