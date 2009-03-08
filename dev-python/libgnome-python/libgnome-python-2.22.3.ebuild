# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libgnome-python/libgnome-python-2.22.3.ebuild,v 1.5 2009/03/08 15:59:15 maekke Exp $

G_PY_PN="gnome-python"
G_PY_BINDINGS="gnome gnomeui"

inherit gnome-python-common

DESCRIPTION="Python bindings for essential GNOME libraries"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=gnome-base/libgnome-2.8
	>=gnome-base/libgnomeui-2.8
	>=dev-python/pyorbit-2.0.1
	>=dev-python/libbonobo-python-${PV}
	>=dev-python/gnome-vfs-python-${PV}
	>=dev-python/libgnomecanvas-python-${PV}
	!<dev-python/gnome-python-2.22.1"
DEPEND="${RDEPEND}"

EXAMPLES="examples/*
	examples/popt/*"
