# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Peter Gavin <pete@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/parted/parted-1.4.21.ebuild,v 1.2 2002/03/06 18:55:22 gbevin Exp $

S=${WORKDIR}/${P}
DESCRIPTION="an advanced partition modification system"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/${PN}"

DEPEND="virtual/glibc
	>=sys-apps/e2fsprogs-1.19-r2
	readline? ( >=sys-libs/readline-4.1-r2 )
	nls? ( >=sys-devel/gettext-0.10.38 )
	python? ( >=dev-lang/python-2.0 )"


src_compile() {

	if [ "`use readline`" ]
	then
		myconf="${myconf} --with-readline"
	fi
	if [ "`use python`" ]
	then
	myconf="${myconf} --with-python"
	fi
	if [ -z "`use nls`" ]
	then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf}"
	fi
	
	./configure --prefix=/usr \
		--target=${CHOST} \
		${myconf} || die
		
	emake || die
}

src_install() {

	make DESTDIR=${D} install || die
	
	if [ -z "`use bootcd`" ]
	then
		dodoc ABOUT-NLS AUTHORS BUGS COPYING ChangeLog NEWS README THANKS TODO
		cd doc ; docinto doc
		dodoc API COPYING.DOC FAT USER USER.jp
	else
		rm -rf ${D}/usr/share ${D}/usr/include ${D}/usr/lib/lib*.{a,la}
	fi
}
