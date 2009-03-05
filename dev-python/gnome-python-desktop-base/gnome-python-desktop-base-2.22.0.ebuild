# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-desktop-base/gnome-python-desktop-base-2.22.0.ebuild,v 1.4 2009/03/05 23:32:12 ranger Exp $

inherit versionator eutils autotools gnome2

# This ebuild does nothing -- we just want to get the pkgconfig file installed
MY_PN="gnome-python-desktop"
DESCRIPTION="Provides python the base files for the Gnome Python Desktop bindings"
HOMEPAGE="http://pygtk.org/"
PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP}/${MY_PN}-${PV}.tar.bz2
	mirror://gentoo/${MY_PN}-${PV}-split.patch.gz"

IUSE=""
LICENSE="LGPL-2.1"
SLOT="0"
RESTRICT="${RESTRICT} test"

# From the gnome-python-desktop eclass
RDEPEND="virtual/python
	>=dev-python/pygtk-2.10.3
	>=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.4.0
	!<dev-python/gnome-python-extras-2.13
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7"

KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	gnome2_src_unpack
	cd "${S}"
	epatch "${WORKDIR}/${MY_PN}-${PV}-split.patch"
	eautoreconf
}

src_compile() {
	G2CONF="${G2CONF} --disable-allbindings"
	gnome2_src_compile
}
