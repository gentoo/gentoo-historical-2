# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hfsutils/hfsutils-3.2.6-r2.ebuild,v 1.4 2003/07/16 17:50:29 pvdabeel Exp $

DESCRIPTION="HFS FS Access utils"
SRC_URI="ftp://ftp.mars.org/pub/hfs/${P}.tar.gz"
HOMEPAGE="http://www.mars.org/home/rob/proj/hfs/"
IUSE="tcltk"

KEYWORDS="ppc ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
        tcltk? ( dev-lang/tcl dev-lang/tk )"
RDEPEND=""

MAKEOPTS='PREFIX=/usr MANDIR=/usr/share/man'

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/hfsutils-3.2.6-errno.patch 
}

src_compile() {
	local myconf
	use tcltk && myconf="--with-tcl --with-tk"
	
	econf ${myconf} || die
	emake || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/lib
	dodir /usr/share/man/man1
	make \
		prefix=${D}/usr \
		MANDEST=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
}
