# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xxe/xxe-2.3_p1.ebuild,v 1.3 2003/10/27 13:26:45 aliz Exp $

S="${WORKDIR}/xxe-std-23p1"
DESCRIPTION="Java-based XML Editor"
SRC_URI="http://www.xmlmind.net/xmleditor/_download/xxe-std-23p1.tar.gz"
HOMEPAGE="http://www.xmlmind.com/xmleditor/index.html"
IUSE=""

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86"

RESTRICT="nostrip nomirror"
RDEPEND=">=virtual/jdk-1.4.1"
DEPEND=""
INSTALLDIR=/opt/xxe

src_compile() {
	einfo "Nothing to compile, this is a binary package."
}

src_install() {
	dodir ${INSTALLDIR}
	cp -a ${S}/* ${D}/${INSTALLDIR}

	#dynamic environment by T.Henderson@cs.ucl.ac.uk (Tristan Henderson)
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > \
		${D}/etc/env.d/10xxe23
}
