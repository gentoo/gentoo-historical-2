# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/amaya/amaya-6.1.ebuild,v 1.1 2002/06/02 13:04:47 stroke Exp $

S=${WORKDIR}/Amaya/LINUX-ELF
DESCRIPTION="The W3C Web-Browser"
SRC_URI="ftp://ftp.w3.org/pub/amaya/${PN}-src-${PV}.tgz"
HOMEPAGE="http://www.w3.org/Amaya/"
LICENSE="GPL-2"
SLOT="0"

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

