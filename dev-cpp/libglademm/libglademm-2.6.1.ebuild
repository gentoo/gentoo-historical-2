# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libglademm/libglademm-2.6.1.ebuild,v 1.8 2006/08/13 18:29:10 corsair Exp $

inherit gnome2

DESCRIPTION="C++ bindings for libglade"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.4"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=gnome-base/libglade-2.3.6
	>=dev-cpp/gtkmm-2.6"
DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

src_compile() {
	if useq amd64; then
		aclocal -I scripts
		libtoolize --force --copy
		automake -c -f
		autoconf
	fi

	gnome2_src_compile
}

DOCS="AUTHORS ChangeLog NEWS README TODO"
