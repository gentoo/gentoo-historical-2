# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/x2x/x2x-1.27.ebuild,v 1.2 2002/07/08 21:31:07 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="An utility to connect the Mouse and KeyBoard to another X"
HOMEPAGE="http://www.the-labs.com/X11/#x2x"
LICENSE="as-is"
DEPEND="virtual/x11"
RDEPEND="virtual/x11"
SRC_URI="http://ftp.digital.com/pub/Digital/SRC/x2x/${P}.tar.gz"
SLOT="0"
KEYWORDS="x86"

src_unpack() {
	unpack ${A}
	cd ${S}
	gunzip < ${FILESDIR}/${P}.diff.gz | patch || die "patch failed"
}

src_compile() {
	xmkmf
	cp x2x.1 x2x.man
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	doman x2x.1
	dodoc ${S}/LICENSE
}
