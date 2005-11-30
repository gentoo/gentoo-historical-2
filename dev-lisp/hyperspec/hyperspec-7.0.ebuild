# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/hyperspec/hyperspec-7.0.ebuild,v 1.1 2005/04/16 05:17:23 mkennedy Exp $

MY_PV=${PV/./-}

DESCRIPTION="Common Lisp ANSI-standard Hyperspec"
HOMEPAGE="http://www.lispworks.com/reference/HyperSpec/"
SRC_URI=""
LICENSE="HyperSpec"
SLOT="0"
KEYWORDS="x86 amd64 ppc"
IUSE=""
DEPEND=""

# URL: ftp://ftp.lispworks.com/pub/software_tools/reference/HyperSpec-7-0.tar.gz

S=${WORKDIR}/

src_unpack() {
	if [ ! -f ${DISTDIR}/HyperSpec-${MY_PV}.tar.gz ] ; then
		echo
		einfo ">>> The HyperSpec cannot be redistributed.  Download the HyperSpec-7-0.tar.gz "
		einfo ">>> file from http://www.lispworks.com/documentation/HyperSpec/ and move it to "
		einfo ">>> /usr/portage/distfiles before rerunning emerge.	The legal conditions are "
		einfo ">>> described at http://www.lispworks.com/reference/HyperSpec/Front/Help.htm#Legal"
		die
	else
		unpack HyperSpec-${MY_PV}.tar.gz
	fi
}

src_install() {
	dodir /usr/share/doc/${P}
	cp -r HyperSpec* ${D}/usr/share/doc/${P}
#	cd ${D}/usr/share/doc/${P} && tar xfz ${DISTDIR}/HyperSpec-${MY_PV}.tar.gz || die
}

