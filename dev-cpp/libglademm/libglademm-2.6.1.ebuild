# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libglademm/libglademm-2.6.1.ebuild,v 1.1 2005/09/19 12:08:40 ka0ttic Exp $

inherit gnome2

DESCRIPTION="C++ bindings for libglade"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.4"
KEYWORDS="~amd64 ~ppc ~x86 ~sparc ~ppc64 ~hppa"
IUSE=""

RDEPEND=">=gnome-base/libglade-2.3.6
	>=dev-cpp/gtkmm-2.6"
DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

src_compile() {
	if useq amd64 || useq ppc64; then
		aclocal -I scripts
		libtoolize --force --copy
		automake -c -f
		autoconf
	fi

	gnome2_src_compile
}

DOCS="AUTHORS ChangeLog NEWS README TODO"
