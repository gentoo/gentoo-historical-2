# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/amaya/amaya-4.1-r1.ebuild,v 1.6 2002/10/04 06:18:51 vapier Exp $

S=${WORKDIR}/Amaya/LINUX-ELF
DESCRIPTION="The W3C Web-Browser"
SRC_URI="ftp://ftp.w3.org/pub/amaya/${PN}-src-${PV}.tgz"
HOMEPAGE="http://www.w3.org/Amaya/"
KEYWORDS="x86 sparc sparc64"
SLOT="0"
LICENSE="BSD"

DEPEND=">=x11-libs/openmotif-2.1.30 sys-devel/perl"
RDEPEND=">=x11-libs/openmotif-2.1.30"

src_compile() {

	mkdir ${S}
	cd ${S}

	../configure --prefix=/usr --host=${CHOST} || die
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

