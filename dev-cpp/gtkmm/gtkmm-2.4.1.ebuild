# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.4.1.ebuild,v 1.2 2004/05/09 15:43:48 khai Exp $

inherit gnome2

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~x86"

RDEPEND=">=dev-cpp/glibmm-2.4
	>=x11-libs/gtk+-2.4
	>=dev-libs/libsigc++-2.0"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS CHANGES ChangeLog HACKING PORTING NEWS README TODO"

src_compile() {
	gnome2_src_compile
}
