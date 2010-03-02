# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/printer-applet/printer-applet-4.4.1.ebuild,v 1.1 2010/03/02 19:41:40 tampakrap Exp $

EAPI="3"

KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="KDE printer system tray utility"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="
	>=app-admin/system-config-printer-common-1.1.12
	app-misc/hal-cups-utils
	$(add_kdebase_dep pykde4)
"
RDEPEND="${DEPEND}"

src_prepare() {
	kde4-meta_src_prepare

	# Rename printer-applet -> printer-applet-kde
	local newname="printer-applet-kde"
	sed -e "/PYKDE4_ADD_EXECUTABLE/s/ printer-applet[[:space:]]*)/ ${newname})/" \
		-e "/install/s/)/ RENAME ${newname}.desktop)/" \
		-i "${PN}"/CMakeLists.txt || die "failed to rename printer-applet executable"
	sed -e "/Exec/s/printer-applet/${newname}/" \
		-i "${PN}"/printer-applet.desktop || die "failed to patch .desktop file"
}
