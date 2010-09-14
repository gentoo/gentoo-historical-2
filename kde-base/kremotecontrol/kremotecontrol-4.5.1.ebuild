# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kremotecontrol/kremotecontrol-4.5.1.ebuild,v 1.4 2010/09/14 18:05:03 josejx Exp $

EAPI="3"

KDE_HANDBOOK="optional"
KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="KDE frontend for remote controls"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep solid)
"
RDEPEND="${DEPEND}"

src_unpack() {
	if use handbook; then
		KMEXTRA="doc/kcontrol/kremotecontrol"
	fi

	kde4-meta_src_unpack
}

src_prepare() {
	kde4-meta_src_prepare

	sed -e 's:${KDE4WORKSPACE_SOLIDCONTROL_LIBRARY}:solidcontrol:g' \
		-i kremotecontrol/{kcmremotecontrol,kded,krcdnotifieritem,libkremotecontrol}/CMakeLists.txt \
		|| die
}
