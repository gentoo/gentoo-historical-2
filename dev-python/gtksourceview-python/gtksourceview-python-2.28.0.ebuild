# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gtksourceview-python/gtksourceview-python-2.28.0.ebuild,v 1.3 2010/05/24 13:44:43 nixnut Exp $

GCONF_DEBUG="no"
G_PY_PN="gnome-python-desktop"

inherit gnome-python-common

DESCRIPTION="Python bindings for the gtksourceview (version 1.8) library"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="=x11-libs/gtksourceview-1.8*
	>=dev-python/libgnomeprint-python-2.25.90
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/gtksourceview/*"

pkg_postinst() {
	elog
	elog "This package provides python bindings for x11-libs/gtksourceview-1.8."
	elog "If you want to 2.* python bindings, use dev-python/pygtksourceview-2"
}
