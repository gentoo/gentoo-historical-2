# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.2.8.ebuild,v 1.5 2004/01/14 18:46:26 gustavoz Exp $

inherit gnome2

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="x86 ~ppc ~sparc hppa ~amd64 ~alpha"
IUSE=""

RDEPEND=">=dev-libs/glib-2.2
	>=x11-libs/gtk+-2.2
	>=dev-libs/libsigc++-1.2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	!=sys-devel/gcc-3.3.0*"

DOCS="AUTHORS CHANGES ChangeLog HACKING PORTING NEWS README TODO"

src_compile() {
	[ "${ARCH}" = "amd64" ] && libtoolize -c -f
	econf || die
	emake || die
}
