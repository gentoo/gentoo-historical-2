# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/lzo/lzo-1.08-r1.ebuild,v 1.5 2004/03/07 17:06:48 tgall Exp $

DESCRIPTION="An extremely fast compression and decompression library"
HOMEPAGE="http://www.oberhumer.com/opensource/lzo/"
SRC_URI="http://www.oberhumer.com/opensource/lzo/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ia64 ppc64"

DEPEND="x86? ( dev-lang/nasm )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-gcc3.patch
	autoconf
}

src_compile() {
	econf --enable-shared || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README THANKS doc/LZO*
	docinto examples
	dodoc examples/*.c examples/Makefile
}
