# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/blender/blender-2.14-r1.ebuild,v 1.1 2001/10/06 15:30:16 danarmak Exp $

S=${WORKDIR}/blender${PV}-linux-glibc2.1.2-i386
DESCRIPTION="Extremely fast and versatile 3D rendering package"
SRC_URI="ftp://ftp.blender.nl/pub/blender${PV}-linux-glibc2.1.2-i386.tar.gz ftp://ftp.blender.nl/pub/manual_1.5.zip"
HOMEPAGE="http://www.blender.nl"

DEPEND="app-arch/unzip"
RDEPEND="virtual/x11"

src_install () {
    dodir /opt
    cd ${D}/opt
    tar xzf ${DISTDIR}/blender${PV}-linux-glibc2.1.2-i386.tar.gz
    mv blender${PV}-linux-glibc2.1.2-i386 blender-${PV}
    dodir /usr/share/doc/${P}
    cd ${D}/usr/share/doc/${P}
    unzip ${DISTDIR}/manual_1.5.zip
    mv manual_1.5 html
    insinto /usr/bin
    insopts -m755
    newins ${FILESDIR}/${P} blender
	dodir /usr/bin
	dosym /opt/blender-${PV}/blender /usr/bin/blender
}

