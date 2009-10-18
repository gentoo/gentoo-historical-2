# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmenuedit/kmenuedit-4.3.1.ebuild,v 1.3 2009/10/18 16:50:45 maekke Exp $

EAPI="2"

KMNAME="kdebase-workspace"
inherit kde4-meta

DESCRIPTION="KDE menu editor"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug +handbook"

RDEPEND="
	>=kde-base/khotkeys-${PV}:${SLOT}[kdeprefix=]
"

KMEXTRACTONLY="
	libs/kworkspace/
"

src_configure() {
	sed -i -e \
		"s:\${CMAKE_CURRENT_BINARY_DIR}/../khotkeys/app/org.kde.khotkeys.xml:${KDEDIR}/share/dbus-1/interfaces/org.kde.khotkeys.xml:g" \
		kmenuedit/CMakeLists.txt \
		|| die "sed failed"

	kde4-meta_src_configure
}
