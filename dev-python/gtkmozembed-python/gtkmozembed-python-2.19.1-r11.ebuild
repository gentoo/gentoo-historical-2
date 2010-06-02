# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gtkmozembed-python/gtkmozembed-python-2.19.1-r11.ebuild,v 1.12 2010/06/02 21:31:20 eva Exp $

EAPI="2"
G_PY_PN="gnome-python-extras"

inherit confutils gnome-python-common

PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${G_PY_PN}/${PVP}/${G_PY_PN}-${PV}.tar.bz2
	mirror://gentoo/${G_PY_PN}-${PV}-split.patch.gz"

DESCRIPTION="Python bindings for the GtkMozEmbed Gecko library"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="hppa ppc64"
IUSE="doc"

RDEPEND="=net-libs/xulrunner-1.9*"
DEPEND="${RDEPEND}"

pkg_setup() {
	gnome-python-common_pkg_setup

	G2CONF="${G2CONF} --with-gtkmozembed=xulrunner-1.9"
}

src_prepare() {
	epatch "${WORKDIR}/${G_PY_PN}-${PV}-split.patch"

	# Accomodate new releases of libtool
	epatch "${FILESDIR}/${P}-libtool2.patch"

	# Allow building with xulrunner 1.9, bug #
	rm "${S}/gtkmozembed/gtkmozembedmodule.c"
	epatch "${FILESDIR}/${P}-xulrunner19.patch"

	eautoreconf
	gnome-python-common_src_prepare
}
