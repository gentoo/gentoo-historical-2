# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/openh323/openh323-1.8.8.ebuild,v 1.1 2002/07/05 22:25:38 raker Exp $

S="${WORKDIR}/openh323"
SRC_URI="http://www.gnomemeeting.org/downloads/latest/sources/openh323_${PV}.tar.gz"
HOMEPAGE="http://www.openh323.org"
DEPEND="virtual/glibc =dev-libs/pwlib-1.2.19"
SLOT="1.8"
KEYWORDS="x86"

src_compile() {
	cd ${S}
	export PWLIBDIR=/usr/share/pwlib
	export OPENH323DIR=${S}
	echo $PWLIBDIR
	make optshared || die
}

src_install() {
   mkdir -p ${D}/usr/lib
   mkdir -p ${D}/usr/share/openh323
   cd ${S}/lib
   mv lib* ${D}/usr/lib
   cd ${S}
   cp -a * ${D}/usr/share/openh323
   rm -rf ${D}/usr/share/openh323/make/CVS
   rm -rf ${D}/usr/share/openh323/tools/CVS
   rm -rf ${D}/usr/share/openh323/tools/asnparser/CVS
   rm -rf ${D}/usr/share/openh323/src
   rm -rf ${D}/usr/share/openh323/include/CVS
   rm -rf ${D}/usr/share/openh323/include/ptlib/unix/CVS
   rm -rf ${D}/usr/share/openh323/include/ptlib/CVS

   cd ${D}/usr/lib
   ln -sf libh323_linux_x86_r.so.${PV} libopenh323.so
}


