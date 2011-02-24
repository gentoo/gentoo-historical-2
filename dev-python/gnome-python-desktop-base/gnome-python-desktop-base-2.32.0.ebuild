# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-desktop-base/gnome-python-desktop-base-2.32.0.ebuild,v 1.3 2011/02/24 18:46:34 tomka Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2"

inherit gnome2 versionator python

# This ebuild does nothing -- we just want to get the pkgconfig file installed
MY_PN="gnome-python-desktop"
PVP="$(get_version_component_range 1-2)"

DESCRIPTION="Provides python the base files for the Gnome Python Desktop bindings"
HOMEPAGE="http://pygtk.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP}/${MY_PN}-${PV}.tar.bz2"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"

IUSE=""
LICENSE="LGPL-2.1"
SLOT="0"

# From the gnome-python-desktop eclass
RDEPEND=">=dev-python/pygtk-2.10.3
	>=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.4.0
	!<dev-python/gnome-python-extras-2.13
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7"

RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
	G2CONF="${G2CONF} --disable-allbindings"
	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare
	python_convert_shebangs -r 2 .
}
