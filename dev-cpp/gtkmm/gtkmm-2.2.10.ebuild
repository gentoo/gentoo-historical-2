# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.2.10.ebuild,v 1.12 2005/01/01 17:27:08 eradicator Exp $

inherit gnome2

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://gtkmm.sourceforge.net/"
IUSE=""
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="x86 ppc sparc ~alpha hppa amd64 ~ia64"

RDEPEND=">=dev-libs/glib-2.2
	>=x11-libs/gtk+-2.2
	=dev-libs/libsigc++-1.2*"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	!=sys-devel/gcc-3.3.0*"

DOCS="AUTHORS CHANGES ChangeLog HACKING PORTING NEWS README TODO"

src_compile() {

	if [ "${ARCH}" = "amd64" ]; then
		libtoolize -c -f --automake
		aclocal -I scripts
		automake
		autoconf
	fi

	gnome2_src_compile

}
