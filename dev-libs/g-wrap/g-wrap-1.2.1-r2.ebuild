# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/g-wrap/g-wrap-1.2.1-r2.ebuild,v 1.12 2004/06/24 23:12:00 agriffis Exp $

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="A tool for exporting C libraries into Scheme"
SRC_URI="http://www.gnucash.org/pub/g-wrap/source/${P}.tar.gz"
HOMEPAGE="http://www.gnucash.org"

# g-wrap should never have been slotted, since the files overlap significantly
SLOT="1.3"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"

DEPEND=">=dev-util/guile-1.4
	>=dev-libs/slib-2.4.1"

src_compile() {

	# fix the "relink" bug in older versions of libtool
	elibtoolize

	econf \
		--libexecdir=/usr/lib/misc || die

	#GCC3 Compile fix, I tried to do this at the Makefile.in level
	#but it hates me with a passion so it goes here.
	for FILE in `find . -iname "Makefile"`
	do
		mv ${FILE} ${FILE}.old
		sed -e "s:-I/usr/include::" ${FILE}.old > ${FILE}
	done

	make || die
}

src_install () {

	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README THANKS
}
