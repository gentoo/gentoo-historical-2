# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.4.1.ebuild,v 1.9 2004/07/14 02:37:43 lv Exp $

inherit gnome2

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.4"
KEYWORDS="~x86 amd64 ~ppc"
IUSE=""

RDEPEND=">=dev-cpp/glibmm-2.4
	>=x11-libs/gtk+-2.4
	>=dev-libs/libsigc++-2.0
	>=dev-libs/atk-1.6"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS CHANGES ChangeLog HACKING PORTING NEWS README TODO"

src_compile() {
	if [ "${ARCH}" = "amd64" ]; then
		aclocal -I scripts
		automake
		autoconf
	fi
	gnome2_src_compile
}
