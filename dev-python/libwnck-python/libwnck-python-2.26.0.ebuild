# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libwnck-python/libwnck-python-2.26.0.ebuild,v 1.9 2010/01/17 23:51:03 jer Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="wnck"

inherit gnome-python-common

DESCRIPTION="Python bindings for the libwnck library"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=x11-libs/libwnck-2.19.3
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/wnck_example.py"
