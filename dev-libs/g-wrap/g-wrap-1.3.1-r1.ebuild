# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/g-wrap/g-wrap-1.3.1-r1.ebuild,v 1.3 2002/08/01 11:59:01 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A tool for exporting C libraries into Scheme"
SRC_URI="ftp://ftp.gnucash.org/pub/g-wrap/source/${P}.tar.gz"
HOMEPAGE="http://"

DEPEND=">=sys-libs/glibc-2.1.3
	>=dev-util/guile-1.4
	>=dev-libs/slib-2.4.1"


src_unpack() {

	unpack ${A}
}

src_compile() {

	./configure --host=${CHOST}					\
		    --prefix=/usr					\
		    --libexecdir=/usr/lib/misc 				\
		    --infodir=/usr/share/info || die

	#GCC3 Compile fix, I tried to do this at the Makefile.in level
	#but it hates me with a passion so it goes here.
	for FILE in `find . -iname "Makefile"`
	do
		mv ${FILE} ${FILE}.old
		sed -e "s:-I/usr/include::" ${FILE}.old > ${FILE}
	done

	emake || die
}

src_install () {

	make DESTDIR=${D} install || die
}
