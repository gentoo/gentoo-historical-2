# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/zprod-manager/zprod-manager-0.3.2-r1.ebuild,v 1.2 2008/11/08 15:16:49 nixnut Exp $

DESCRIPTION="Gentoo Zope Product selection tool"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

SLOT="0"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="~amd64 ppc ~sparc ~x86"

DEPEND=""
RDEPEND="dev-util/dialog
	net-zope/zope"

src_install() {
	dosbin "${FILESDIR}/${PV}"/zprod-manager || die "install failed"
}
