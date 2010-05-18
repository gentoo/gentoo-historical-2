# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/librsvg-python/librsvg-python-2.28.0.ebuild,v 1.2 2010/05/18 12:48:47 phajdan.jr Exp $

GCONF_DEBUG="no"
G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="rsvg"

inherit gnome-python-common

DESCRIPTION="Python bindings for the librsvg library"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=gnome-base/librsvg-2.13.93
	dev-python/pycairo
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/rsvg/*"
