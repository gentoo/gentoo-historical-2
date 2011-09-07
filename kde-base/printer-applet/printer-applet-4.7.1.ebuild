# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/printer-applet/printer-applet-4.7.1.ebuild,v 1.1 2011/09/07 20:13:57 alexxy Exp $

EAPI=3

KDE_HANDBOOK="optional"
PYTHON_DEPEND="2"
KDE_SCM="git"
if [[ ${PV} == *9999 ]]; then
	kde_eclass="kde4-base"
else
	KMNAME="kdeutils"
	kde_eclass="kde4-meta"
fi
inherit python ${kde_eclass}

DESCRIPTION="KDE printer system tray utility"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=app-admin/system-config-printer-common-1.2.2
	$(add_kdebase_dep pykde4)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	${kde_eclass}_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	${kde_eclass}_src_prepare

	# Rename printer-applet -> printer-applet-kde
	local newname="printer-applet-kde"
	sed -e "/PYKDE4_ADD_EXECUTABLE/s/ printer-applet[[:space:]]*)/ ${newname})/" \
		-e "/install/s/)/ RENAME ${newname}.desktop)/" \
		-i printer-applet/CMakeLists.txt || die "failed to rename printer-applet executable"
	sed -e "/Exec/s/printer-applet/${newname}/" \
		-i printer-applet/printer-applet.desktop || die "failed to patch .desktop file"
}

src_install() {
	${kde_eclass}_src_install
	python_convert_shebangs -q -r $(python_get_version) "${ED}"
}

pkg_postrm() {
	python_mod_cleanup "${PREFIX}share/apps/${PN}"
}
