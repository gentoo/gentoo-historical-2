# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-lang/jdk/jdk-1.3.1.ebuild,v 1.2 2001/07/10 03:17:07 achim Exp $

P=jdk-1.3.1
A=j2sdk-1.3.1-FCS-linux-i386.tar.bz2
S=${WORKDIR}/j2sdk1.3.1
DESCRIPTION="Blackdown JDK 1.3.1"
SRC_URI="http://www.ibiblio.org/pub/linux/devel/lang/java/blackdown.org/JDK-1.3.1/i386/FCS/${A}"
HOMEPAGE="http://www.blackdown.org/java-linux.html"

DEPEND="virtual/glibc"
RDEPEND="virtual/glibc
	virtual/x11"

src_install() {
  dodir /opt/jdk-${PV}
  dodir /usr/share
  cp -a ${S}/bin ${D}/opt/jdk-${PV}
  cp -a ${S}/demo ${D}/opt/jdk-${PV}
  cp -a ${S}/include ${D}/opt/jdk-${PV}
  cp -a ${S}/lib ${D}/opt/jdk-${PV}
  cp -a ${S}/jre ${D}/opt/jdk-${PV}
  cp -a ${S}/man ${D}/usr/share
  cp    ${S}/src.jar ${D}/opt/jdk-${PV}
  into /usr
  dodoc COPYRIGHT LICENSE README
  insinto /etc/env.d
  doins ${FILESDIR}/20jdk
  docinto html
  dodoc README.html
}

pkg_postinst () {
  ln -sf ${ROOT}/opt/jdk-${PV} ${ROOT}/opt/java
}


