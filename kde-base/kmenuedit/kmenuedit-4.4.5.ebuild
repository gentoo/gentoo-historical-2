# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmenuedit/kmenuedit-4.4.5.ebuild,v 1.5 2010/08/09 17:34:44 scarabeus Exp $

EAPI="3"

KMNAME="kdebase-workspace"
inherit kde4-meta

DESCRIPTION="KDE menu editor"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

RDEPEND="
	$(add_kdebase_dep khotkeys)
"

KMEXTRACTONLY="
	libs/kworkspace/
"

src_configure() {
	sed -i -e \
		"s:\${CMAKE_CURRENT_BINARY_DIR}/../khotkeys/app/org.kde.khotkeys.xml:${EKDEDIR}/share/dbus-1/interfaces/org.kde.khotkeys.xml:g" \
		kmenuedit/CMakeLists.txt \
		|| die "sed failed"

	kde4-meta_src_configure
}
