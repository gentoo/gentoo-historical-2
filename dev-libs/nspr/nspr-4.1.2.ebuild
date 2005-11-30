# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nspr/nspr-4.1.2.ebuild,v 1.1 2002/02/10 21:21:28 karltk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Netscape Portabel Runtime"
SRC_URI="ftp://ftp.mozilla.org/pub/nspr/releases/v${PV}/src/${P}.tar.gz"
HOMEPAGE="http://www.mozilla.org/projects/nspr/"

DEPEND="virtual/glibc"
#RDEPEND=""

src_unpack() {
	unpack ${P}.tar.gz
	mkdir ${S}/build
	mkdir ${S}/inst
}
src_compile() {
	cd ${S}/build
	../mozilla/nsprpub/configure \
		--host=${CHOST} \
		--prefix=${S}/inst \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	make || die
}

src_install () {
	# Their build system is royally fucked, as usual
	dolib ${S}/inst/bin/lib*.so 
	dolib ${S}/inst/lib/lib*.a

	insinto /usr/include/nspr
	doins ${S}/inst/include/*.h

	insinto /usr/include/nspr/md
	doins ${S}/inst/include/md/*.cfg

	insinto /usr/include/nspr/private
	doins ${S}/inst/include/private/*.h

	insinto /usr/include/nspr/obsolete
	doins ${S}/inst/include/obsolete/*.h

	cd ${S}/mozilla/nsprpub
}
