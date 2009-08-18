# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/partitionmanager/partitionmanager-1.0.0.ebuild,v 1.1 2009/08/18 08:18:30 scarabeus Exp $

EAPI="2"

KDE_LINGUAS="bg ca da de el en_GB es et fr gl ja lt nb nds nl nn pa pl pt
pt_BR ro ru sv tr uk zh_CN zh_TW"

KMNAME="extragear/sysadmin"
inherit kde4-base

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="KDE utility for management of partitions and file systems."
HOMEPAGE="http://partitionman.sourceforge.net/"
SRC_URI="mirror://sourceforge/partitionman/${MY_P/beta/BETA}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="
	sys-apps/parted
	sys-libs/e2fsprogs-libs
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S="${WORKDIR}/${MY_P/beta/BETA}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DPARTMAN_KPART=ON
		-DPARTMAN_KCM=ON
	"

	kde4-base_src_configure
}

src_test() {
	mycmakeargs="${mycmakeargs}
		-DKDE4_BUILD_TESTS=ON"
	kde4-base_src_test
}
