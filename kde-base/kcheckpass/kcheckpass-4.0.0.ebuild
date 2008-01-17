# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcheckpass/kcheckpass-4.0.0.ebuild,v 1.1 2008/01/17 23:36:20 philantrop Exp $

EAPI="1"

KMNAME=kdebase-workspace
inherit kde4-meta

DESCRIPTION="A simple password checker, used by any software in need of user authentication."
KEYWORDS="~amd64 ~x86"
IUSE="pam"

DEPEND="
	pam? ( >=kde-base/kdebase-pam-7
		sys-libs/pam )"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/kdebase-${PV}-pam-optional.patch"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with pam PAM)"
	kde4-meta_src_compile
}
