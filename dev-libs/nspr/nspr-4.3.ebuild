# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nspr/nspr-4.3.ebuild,v 1.7 2003/11/14 03:07:50 brad_mssw Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Netscape Portable Runtime"
SRC_URI="ftp://ftp.mozilla.org/pub/nspr/releases/v${PV}/src/${P}.tar.gz"
HOMEPAGE="http://www.mozilla.org/projects/nspr/"

SLOT="0"
LICENSE="MPL-1.1"
KEYWORDS="x86 sparc ppc ~alpha ~amd64"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	mkdir ${S}/build
	mkdir ${S}/inst
	if [ "${ARCH}" = "amd64" ]
	then
		cd ${S}; epatch ${FILESDIR}/${PN}-4.3-amd64.patch
	fi
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
	cd ${S}/build
	make install
	dodir /usr
	cp -rfL dist/* ${D}/usr
}
