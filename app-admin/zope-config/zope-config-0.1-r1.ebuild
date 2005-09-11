# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/zope-config/zope-config-0.1-r1.ebuild,v 1.14 2005/09/11 15:06:34 agriffis Exp $

DESCRIPTION="A Gentoo Zope multi-Instance configure tool"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc"
IUSE=""

DEPEND=""
RDEPEND=">=dev-util/dialog-0.7
	sys-apps/grep
	sys-apps/sed"

PDEPEND=">=net-zope/zope-2.6.0-r2"

src_install() {
	dosbin ${FILESDIR}/${PV}/zope-config
}
