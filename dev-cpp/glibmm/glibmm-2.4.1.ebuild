# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/glibmm/glibmm-2.4.1.ebuild,v 1.6 2004/05/30 15:17:35 kugelfang Exp $

inherit gnome2

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://gtkmm.sourceforge.net/"
IUSE=""
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

RDEPEND=">=dev-libs/libsigc++-2.0
		>=dev-libs/glib-2.4"

src_compile () {
	if [ "${ARCH}" = "amd64" ]; then
		aclocal -I scripts
		automake -c -f
		autoconf
	fi
	gnome2_src_compile
}

DOCS="AUTHORS CHANGES ChangeLog HACKING PORTING NEWS README TODO"

