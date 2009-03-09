# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kvpnc/kvpnc-0.9.1.ebuild,v 1.1 2009/03/09 19:30:55 scarabeus Exp $

EAPI=2

KDE_LINGUAS="bg ca da de es fr hu it ja nl pl pt_BR ru sk sv tr zh_CN"
inherit kde4-base

DESCRIPTION="kvpnc - a KDE-VPN connection utility"
HOMEPAGE="http://home.gna.org/kvpnc/"
SRC_URI="http://download.gna.org/kvpnc/${P}-kde4.tar.bz2
	http://download.gna.org/kvpnc/${P}-kde4-locale.tar.bz2"

LICENSE="GPL-2"
SLOT="1" # kde4
KEYWORDS="~amd64 ~x86"
IUSE="+crypt"

DEPEND="!net-misc/kvpnc:0
	sys-devel/gettext
	crypt? ( dev-libs/libgcrypt )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-kde4"

src_unpack() {
	unpack ${A}
	mv "${P}-kde4-locale/po" "${S}/"
	# doing this per line for better readability
	echo "find_package ( Msgfmt REQUIRED )" >> "${S}"/CMakeLists.txt
	echo "find_package ( Gettext REQUIRED )" >> "${S}"/CMakeLists.txt
	echo "add_subdirectory ( po )" >> "${S}"/CMakeLists.txt
}

src_prepare() {
	kde4-base_src_prepare
	# fix package version; how they can release such mess
	sed -i \
		-e "s:0.9.0-svn:0.9.1:g" \
		CMakeLists.txt || die "failed to fix PV"
}

src_configure() {
	mycmakeargs="$(cmake-utils_use_with crypt libgcrypt)"
	kde4-base_src_configure
}
