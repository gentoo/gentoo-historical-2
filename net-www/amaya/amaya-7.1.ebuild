# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/amaya/amaya-7.1.ebuild,v 1.5 2003/03/30 01:06:17 liquidx Exp $

inherit libtool

S=${WORKDIR}/Amaya/LINUX-ELF

DESCRIPTION="The W3C Web-Browser"
SRC_URI="ftp://ftp.w3.org/pub/amaya/${PN}-src-${PV}.tgz
	 ftp://ftp.w3.org/pub/amaya/old/${PN}-src-${PV}.tgz"
HOMEPAGE="http://www.w3.org/Amaya/"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="virtual/motif"
DEPEND="dev-lang/perl
	${RDEPEND}"

src_compile() {
	mkdir ${S}
	cd ${S}

	../configure \
		--without-gtk \
		--prefix=/usr \
		--host=${CHOST}
	make || die
}

src_install () {
	dodir /usr
	make prefix=${D}/usr install || die
	rm ${D}/usr/bin/amaya
	rm ${D}/usr/bin/print
	dosym /usr/Amaya/applis/bin/amaya /usr/bin/amaya
	dosym /usr/Amaya/applis/bin/print /usr/bin/print
}

