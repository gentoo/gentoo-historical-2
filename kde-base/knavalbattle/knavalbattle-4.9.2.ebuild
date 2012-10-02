# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knavalbattle/knavalbattle-4.9.2.ebuild,v 1.1 2012/10/02 18:11:59 johu Exp $

EAPI=4

if [[ ${PV} == *9999 ]]; then
	eclass="kde4-base"
else
	eclass="kde4-meta"
	KMNAME="kdegames"
fi
KDE_HANDBOOK="optional"
inherit games-ggz ${eclass}

DESCRIPTION="The KDE Battleship clone"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="$(add_kdebase_dep libkdegames)"
RDEPEND="${DEPEND}"

add_blocker kbattleship

src_prepare() {
	# cmake is doing this really weird
	if [[ ${PV} == *9999 ]]; then
		sed -i \
			-e "s:register_ggz_module:#register_ggz_module:g" \
			src/CMakeLists.txt || die "ggz removal failed"
	else
		sed -i \
			-e "s:register_ggz_module:#register_ggz_module:g" \
			"${PN}"/src/CMakeLists.txt || die "ggz removal failed"
	fi

	${eclass}_src_prepare
}
