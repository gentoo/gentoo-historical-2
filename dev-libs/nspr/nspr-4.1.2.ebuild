# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nspr/nspr-4.1.2.ebuild,v 1.8 2003/02/13 10:48:18 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Netscape Portable Runtime"
SRC_URI="ftp://ftp.mozilla.org/pub/nspr/releases/v${PV}/src/${P}.tar.gz"
HOMEPAGE="http://www.mozilla.org/projects/nspr/"

SLOT="0"
LICENSE="MPL-1.1"
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc"

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
