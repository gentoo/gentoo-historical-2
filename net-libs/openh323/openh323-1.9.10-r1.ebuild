# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/openh323/openh323-1.9.10-r1.ebuild,v 1.6 2002/12/09 04:33:13 manson Exp $

IUSE="ssl"

S="${WORKDIR}/${PN}"

SRC_URI="http://www.openh323.org/bin/${PN}_${PV}.tar.gz"
HOMEPAGE="http://www.openh323.org"
DESCRIPTION="Open Source implementation of the ITU H.323 teleconferencing protocol"

DEPEND="media-libs/speex
	>=dev-libs/pwlib-1.3.11-r1
	ssl? ( dev-libs/openssl )"

SLOT="0"
LICENSE="MPL-1.1"
KEYWORDS="x86 ppc -sparc "

src_compile() {

	export PWLIBDIR=/usr/share/pwlib
	export OPENH323DIR=${S}

	if [ "`use ssl`" ]; then
		export OPENSSLFLAG=1
		export OPENSSLDIR=/usr
		export OPENSSLLIBS="-lssl -lcrypt"
	fi

	make optshared || die

}

src_install() {

   dodir /usr/lib /usr/share/openh323

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
   if [ ${ARCH} = "ppc" ] ; then
	ln -sf libh323_linux_ppc_r.so.${PV} libopenh323.so
   else
	ln -sf libh323_linux_x86_r.so.${PV} libopenh323.so
   fi


}


