# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gtkhtml-python/gtkhtml-python-2.19.1.ebuild,v 1.3 2008/12/01 14:34:18 eva Exp $

G_PY_PN="gnome-python-extras"
G_PY_BINDINGS="gtkhtml2"

inherit gnome-python-common

PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${G_PY_PN}/${PVP}/${G_PY_PN}-${PV}.tar.bz2
	mirror://gentoo/${G_PY_PN}-${PV}-split.patch.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"

RDEPEND="=gnome-extra/gtkhtml-2*"
DEPEND="${RDEPEND}"

EXAMPLES="examples/gtkhtml2/*"

src_unpack() {
	gnome-python-common_src_unpack

	epatch "${WORKDIR}/${G_PY_PN}-${PV}-split.patch"
	eautoreconf
}

