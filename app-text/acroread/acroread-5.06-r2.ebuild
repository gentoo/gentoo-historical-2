# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/acroread/acroread-5.06-r2.ebuild,v 1.1 2002/11/21 19:28:29 phoenix Exp $

inherit nsplugins

MY_P=linux-${PV/./}
S=${WORKDIR}
DESCRIPTION="Adobe's PDF reader"
SRC_URI="ftp://ftp.adobe.com/pub/adobe/acrobatreader/unix/5.x/${MY_P}.tar.gz"
HOMEPAGE="http://www.adobe.com/products/acrobat/"
IUSE=""

SLOT="0"
LICENSE="Adobe"
KEYWORDS="~x86 -ppc"

RESTRICT="nostrip"
DEPEND="virtual/glibc"
INSTALLDIR=/opt/Acrobat5

src_compile () {
	
	tar xvf LINUXRDR.TAR
	tar xvf COMMON.TAR

	sed -e "s:REPLACE_ME:${INSTALLDIR}/Reader:" \
		bin/acroread.sh > acroread
}

src_install () {
	
	dodir ${INSTALLDIR}
	for i in Browsers Reader Resource
	do
		chown -R root.root ${i}
		cp -a ${i} ${D}${INSTALLDIR}
	done
	

	mv acroread acroread.sed
	sed -e "s:\$PROG =.*:\$PROG = '${INSTALLDIR}/acroread.real':" \
		acroread.sed > acroread
	
	exeinto ${INSTALLDIR}
	doexe acroread
	dodoc README LICREAD.TXT
	dodir /opt/netscape/plugins
	dosym ${INSTALLDIR}/Browsers/intellinux/nppdf.so /opt/netscape/plugins
	
	#dynamic environment by T.Henderson@cs.ucl.ac.uk (Tristan Henderson)
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > \
		${D}/etc/env.d/10acroread5

	inst_plugin ${INSTALLDIR}/Browsers/intellinux/nppdf.so
}
