# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/printer-applet/printer-applet-4.6.3.ebuild,v 1.2 2011/06/08 23:42:42 tomka Exp $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdeutils"
PYTHON_DEPEND="2"
inherit python kde4-meta

DESCRIPTION="KDE printer system tray utility"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE="+handbook"

DEPEND="
	>=app-admin/system-config-printer-common-1.2.2
	$(add_kdebase_dep pykde4)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	kde4-meta_pkg_setup
	python_set_active_version 2
}

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

src_install() {
	kde4-meta_src_install
	python_convert_shebangs -q -r $(python_get_version) "${ED}"
}

pkg_postrm() {
	python_mod_cleanup "${PREFIX}share/apps/${PN}"
}
