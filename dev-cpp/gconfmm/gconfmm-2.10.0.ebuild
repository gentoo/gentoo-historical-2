# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gconfmm/gconfmm-2.10.0.ebuild,v 1.1 2005/07/21 16:28:58 ka0ttic Exp $

inherit gnome2 eutils

DESCRIPTION="C++ bindings for GConf"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=gnome-base/gconf-2.4
	>=dev-cpp/glibmm-2.4
	>=dev-cpp/gtkmm-2.4"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"



DOCS="AUTHORS COPYING* ChangeLog NEWS README INSTALL"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-2.6.1-amd64-gcc4.patch
}

src_compile() {
	if useq amd64 || useq ppc64; then
		aclocal -I scripts
		libtoolize --force --copy
		automake -c -f
		autoconf
	fi

	gnome2_src_compile
}
