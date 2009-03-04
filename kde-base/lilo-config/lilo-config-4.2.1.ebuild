# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/lilo-config/lilo-config-4.2.1.ebuild,v 1.1 2009/03/04 22:45:34 alexxy Exp $

EAPI="2"

KMNAME="kdeadmin"
inherit kde4-meta

DESCRIPTION="KDE LiLo kcontrol module"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="sys-boot/lilo"
DEPEND="${RDEPEND}
	kde-base/kdepimlibs:${SLOT}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DBUILD_lilo-config=TRUE -DLILO_EXECUTABLE=TRUE"

	kde4-meta_src_configure
}
