# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/flex/flex-2.5.31.ebuild,v 1.6 2004/06/24 02:38:26 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNU lexical analyser generator"
SRC_URI="mirror://sourceforge/lex/${P}.tar.bz2"
HOMEPAGE="http://lex.sourceforge.net/"

SLOT="0"
LICENSE="FLEX"
KEYWORDS="~amd64 ~x86 ~ppc ~sparc ~alpha"

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"


src_compile() {
	myconf=""

	use nls || myconf="--disable-nls"

	econf ${myconf} || die

	if ! use static
	then
		emake || make || die
	else
		emake LDFLAGS=-static || die
	fi
}

src_install() {
	einstall || die

	if ! use build
	then
		dodoc AUTHORS COPYING ChangeLog NEWS ONEWS README* RoadMap THANKS TODO
	else
		rm -rf ${D}/usr/share ${D}/usr/include ${D}/usr/lib
	fi

	dosym flex /usr/bin/lex
}

