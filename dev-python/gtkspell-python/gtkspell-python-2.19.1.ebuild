# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gtkspell-python/gtkspell-python-2.19.1.ebuild,v 1.2 2009/01/06 14:30:42 neurogeek Exp $

G_PY_PN="gnome-python-extras"

inherit gnome-python-common

PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${G_PY_PN}/${PVP}/${G_PY_PN}-${PV}.tar.bz2
	mirror://gentoo/${G_PY_PN}-${PV}-split.patch.gz"

DESCRIPTION="GtkSpell bindings for Python"
# The LICENSE with gtkspell-3 is LGPL and there is no way to express this in
# an ebuild, currently. Punt till we actually have to face the issue.
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples"

RDEPEND="=app-text/gtkspell-2*"
DEPEND="${RDEPEND}"

EXAMPLES="examples/gtkspell/*"

src_unpack() {
	gnome-python-common_src_unpack

	epatch "${WORKDIR}/${G_PY_PN}-${PV}-split.patch"
	eautoreconf
}
