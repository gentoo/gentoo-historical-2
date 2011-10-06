# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kactivities/kactivities-4.7.2.ebuild,v 1.1 2011/10/06 18:11:07 alexxy Exp $

EAPI=4

KDE_SCM="git"
KMNAME="kdelibs"

inherit kde4-base

DESCRIPTION="KDE Activity Manager"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="test"

# Split out from kdelibs in 4.7.1-r2
add_blocker kdelibs 4.7.1-r1

src_unpack() {
	kde4-base_src_unpack
	# Move the unpacked sources to where they are expected to be
	[[ $(echo *-${PV}) != ${P} ]] && { mv *-${PV} ${P} || die; }
}

src_prepare() {
	kde4-base_src_prepare

	sed -i -e '/libkdeclarative/s:^:#DONOTWANT:' experimental/CMakeLists.txt || die
}

src_configure() {
	local S="${WORKDIR}/${P}/experimental"

	kde4-base_src_configure
}

src_compile() {
	local S="${WORKDIR}/${P}/experimental"

	kde4-base_src_compile
}

src_install() {
	local S="${WORKDIR}/${P}/experimental"

	kde4-base_src_install
}
