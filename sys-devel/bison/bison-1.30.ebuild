# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-devel/bison/bison-1.30.ebuild,v 1.5 2002/08/01 11:59:04 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A yacc-compatible parser generator"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/bison/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/bison/bison.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc
        nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_compile() {

	local myconf
	if [ -z "`use nls`" ]
	then
		myconf="--disable-nls"
	fi

	./configure --prefix=/usr ${myconf} --datadir=/usr/share \
		--mandir=/usr/share/man --infodir=/usr/share/info --host=${CHOST} || die

	if [ -z "`use static`" ]
	then
		emake ${MAKEOPTS} || die
	else
		emake ${MAKEOPTS} LDFLAGS=-static || die
	fi

}

src_install() {                               

	make prefix=${D}/usr datadir=${D}/usr/share \
		mandir=${D}/usr/share/man infodir=${D}/usr/share/info install || die

	if [ -z "`use build`" ]
	then
		dodoc COPYING AUTHORS NEWS ChangeLog README REFERENCES OChangeLog
		docinto txt
		dodoc doc/FAQ
	else
		rm -rf ${D}/usr/share/man ${D}/usr/share/info
	fi
	
}


