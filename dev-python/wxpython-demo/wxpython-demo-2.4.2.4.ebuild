# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython-demo/wxpython-demo-2.4.2.4.ebuild,v 1.7 2005/03/10 18:19:32 luckyduck Exp $

MY_P=${P/wxpython-demo/wxPythonDemo}

DESCRIPTION="wxPython demo files"
HOMEPAGE="http://www.wxpython.org"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ~sparc ~amd64"
IUSE=""

S="${WORKDIR}/${DOCDIR}"
DOCDIR="wxPython-${PVR}"

src_install() {
	dodir /usr/share/doc/${DOCDIR}
	dodir /usr/share/doc/${DOCDIR}/demo
	dodir /usr/share/doc/${DOCDIR}/samples
	cp -R ${WORKDIR}/${DOCDIR}/demo/* ${D}/usr/share/doc/${DOCDIR}/demo/
	cp -R ${WORKDIR}/${DOCDIR}/samples/* ${D}/usr/share/doc/${DOCDIR}/samples/
}

