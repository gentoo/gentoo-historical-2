# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils/kdeutils-3.4.1.ebuild,v 1.3 2005/07/01 04:56:28 josejx Exp $

inherit kde-dist

DESCRIPTION="KDE utilities"

KEYWORDS="amd64 ~ia64 ppc ~sparc x86"
IUSE="crypt snmp"

DEPEND="~kde-base/kdebase-${PV}
	snmp? ( net-analyzer/net-snmp )"

RDEPEND="${DEPEND}
	crypt? ( app-crypt/gnupg )"

src_compile() {
	use crypt || export DO_NOT_COMPILE="${DO_NOT_COMPILE} kgpg"

	kde_src_compile
}
