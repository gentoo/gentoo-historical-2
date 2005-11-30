# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkglextmm/gtkglextmm-1.1.0.ebuild,v 1.1 2005/07/21 23:18:07 ka0ttic Exp $

inherit gnome2

DESCRIPTION="C++ bindings for gtkglext"
HOMEPAGE="http://gtkglext.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtkglext/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="1.2"
LICENSE="GPL-2 LGPL-2.1"
IUSE="doc"

RDEPEND=">=x11-libs/gtkglext-1
	>=dev-cpp/gtkmm-2.4
	virtual/x11
	virtual/opengl
	virtual/glu"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog* README TODO"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Remove docs from SUBDIRS so that docs are not installed, as
	# we handle it in src_install.
	sed -i -e 's|^\(SUBDIRS =.*\)docs\(.*\)|\1\2|' Makefile.in || \
		die "sed Makefile.in failed"
}

src_compile() {
	if [ "${ARCH}" = "amd64" ]; then
		libtoolize --force
		aclocal -I m4macros
		automake -c -f
		autoconf
	fi
	gnome2_src_compile
}

src_install() {
	gnome2_src_install
	use doc && dohtml -r docs/reference/html/*
}
