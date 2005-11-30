# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/rox-lib/rox-lib-1.9.16.ebuild,v 1.1.1.1 2005/11/30 10:14:30 chriswhite Exp $

DESCRIPTION="ROX-Lib2 - Shared code for ROX applications by Thomas Leonard"

HOMEPAGE="http://rox.sourceforge.net/rox_lib.html"

SRC_URI="mirror://sourceforge/rox/$P.tgz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~ppc ~amd64"

IUSE=""

DEPEND=">=rox-base/rox-2.1.0
	 	>=dev-python/pygtk-1.99.13"

src_install() {
	dodir /usr/lib/
	cp -r ROX-Lib2/ ${D}/usr/lib/
}
