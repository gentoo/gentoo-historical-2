# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/rox-lib/rox-lib-2.0.3-r1.ebuild,v 1.4 2006/11/23 20:01:49 blubb Exp $

NEED_PYTHON="2.3"
inherit python

MY_PN="rox-lib2"
DESCRIPTION="ROX-Lib2 - Shared code for ROX applications by Thomas Leonard"
HOMEPAGE="http://rox.sourceforge.net/desktop/ROX-Lib"
SRC_URI="mirror://sourceforge/rox/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=rox-base/rox-2.2.0
		>=dev-python/pygtk-2.8.2"

S=${WORKDIR}/${MY_PN}-${PV}
src_install() {
	dodir /usr/lib/
	cp -r ROX-Lib2/ ${D}/usr/lib/
	python_mod_optimize ${D}/usr/lib/ROX-Lib2/ >/dev/null 2>&1
	dodir /usr/share/doc/
	dosym /usr/lib/ROX-Lib2/Help /usr/share/doc/${P}
}
