# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/brasero-python/brasero-python-2.28.0.ebuild,v 1.2 2010/05/18 12:52:34 phajdan.jr Exp $

G_PY_PN="gnome-python-desktop"
G_PY_BINDINGS="braseroburn braseromedia"

inherit gnome-python-common

DESCRIPTION="Python bindings for Brasero CD/DVD burning"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=app-cdr/brasero-0.9
	!<dev-python/gnome-python-desktop-2.22.0-r10"
DEPEND="${RDEPEND}"

EXAMPLES="examples/braseroburn/*
	examples/braseromedia/*"
