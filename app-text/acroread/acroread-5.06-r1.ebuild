# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/acroread/acroread-5.06-r1.ebuild,v 1.9 2003/02/16 12:15:38 seemant Exp $

MY_P=linux-${PV/./}
S=${WORKDIR}
DESCRIPTION="Adobe's PDF reader"
SRC_URI="ftp://ftp.adobe.com/pub/adobe/acrobatreader/unix/5.x/${MY_P}.tar.gz"
HOMEPAGE="http://www.adobe.com/products/acrobat/"
IUSE="mozilla"

SLOT="0"
LICENSE="Adobe"
KEYWORDS="x86 -ppc -sparc -alpha -mips -hppa -arm"

RESTRICT="nostrip"

INSTALLDIR=/opt/Acrobat5

src_compile () {
	
	tar -xvf LINUXRDR.TAR  --no-same-owner
	tar -xvf COMMON.TAR  --no-same-owner

	sed -e "s:REPLACE_ME:${INSTALLDIR}/Reader:" \
		bin/acroread.sh > acroread
}

src_install () {
	
	dodir ${INSTALLDIR}
	for i in Browsers Reader Resource
	do
		if [ -d ${i} ] ; then
		chown -R --dereference root.root ${i}
		cp -Rd ${i} ${D}${INSTALLDIR}
		fi
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

	#mozilla compatibility contributed by m3thos@netcabo.pt(Miguel Sousa Filipe)
	use mozilla && ( \
		dodir /usr/lib/mozilla/plugins
		dosym \
			${INSTALLDIR}/Browsers/intellinux/nppdf.so \
				/usr/lib/mozilla/plugins/nppdf.so
	)
}
