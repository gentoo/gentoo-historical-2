# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/winesetuptk/winesetuptk-0.6.0b-r2.ebuild,v 1.9 2002/10/20 18:37:52 vapier Exp $

MY_P1=tcltk-${P}
P=${P}
S=${WORKDIR}/${P}

DESCRIPTION="Setup tool for WiNE adapted from Codeweavers by Debian"
SRC_URI="http://ftp.debian.org/debian/pool/main/w/winesetuptk/${P/-/_}-1.tar.gz"
HOMEPAGE="http://packages.debian.org/unstable/otherosfs/winesetuptk.html"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 -ppc"

DEPEND="virtual/glibc
	virtual/x11"

src_unpack() {

	unpack ${P/-/_}-1.tar.gz
	cd ${S}

	tar zxf ${MY_P1}.tar.gz
	tar zxf ${P}.tar.gz

}

src_compile() {
	
	cd ${S}/${MY_P1}
	./build.sh
	
	cd ${S}/${P}

	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--localstatedir=/var/lib \
		--sysconfdir=/etc/wine \
		--enable-curses \
		--with-tcltk=${S}/${MY_P1} \
		--with-launcher=/usr/bin \
		--with-exe=/usr/bin \
		--with-doc=/usr/share/doc/${P} || die "configure failed"

	make || die "make failed"

}

src_install () {

	cd ${S}/${P}
	make \
		PREFIX_LAUNCHER=${D}/usr/bin \
		PREFIX_EXE=${D}/usr/bin \
		PREFIX_DOC=${D}/usr/share/doc/${P} \
		install || die
	
	dodoc doc/*
}
