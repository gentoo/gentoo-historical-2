# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgnomeuimm/libgnomeuimm-2.0.0.ebuild,v 1.12 2004/06/24 21:50:26 agriffis Exp $

inherit gnome2 eutils

DESCRIPTION="C++ bindings for libgnomeui"
HOMEPAGE="http://gtkmm.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="x86 ppc sparc hppa amd64"
IUSE=""

RDEPEND=">=gnome-base/libgnomeui-2.0.0
	>=dev-cpp/libgnomemm-1.3.10
	>=dev-cpp/libgnomecanvasmm-2.0
	>=dev-cpp/gconfmm-2.0.1
	>=dev-cpp/gtkmm-2.0.0
	>=dev-cpp/libglademm-2.0.0"
DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS INSTALL TODO"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gcc2_fix.patch
}

src_compile() {
	use amd64 && aclocal -I scripts && automake && autoconf
	gnome2_src_compile
}
