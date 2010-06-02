# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gdl-python/gdl-python-2.19.1-r2.ebuild,v 1.6 2010/06/02 21:10:56 eva Exp $

EAPI="2"
G_PY_PN="gnome-python-extras"

inherit gnome-python-common

PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${G_PY_PN}/${PVP}/${G_PY_PN}-${PV}.tar.bz2
	mirror://gentoo/${G_PY_PN}-${PV}-split.patch.gz"

DESCRIPTION="Python bindings for GDL"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=dev-libs/gdl-2.28"
DEPEND="${RDEPEND}"

EXAMPLES="examples/gdl/*"

src_prepare() {
	epatch "${WORKDIR}/${G_PY_PN}-${PV}-split.patch"
	eautoreconf

	# Fix build failure with gdl-2.24
	epatch "${FILESDIR}/${P}-gdlicons.patch"

	# Fix build failure with gdl-2.28
	epatch "${FILESDIR}/${P}-gdlapi-removal.patch"

	gnome-python-common_src_prepare
}
