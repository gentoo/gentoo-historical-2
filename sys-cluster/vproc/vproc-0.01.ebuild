# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/vproc/vproc-0.01.ebuild,v 1.1.1.1 2005/11/30 10:01:46 chriswhite Exp $

DESCRIPTION="vserver proc-security manipulator"
SRC_URI="http://www.13thfloor.at/vserver/s_release/v1.26/${P}.tar.bz2"
HOMEPAGE="http://www.13thfloor.at/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""

src_compile() {
	make || die "compile failed"
}

src_install () {
	dosbin vproc
}
