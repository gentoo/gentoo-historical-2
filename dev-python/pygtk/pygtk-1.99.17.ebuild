# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtk/pygtk-1.99.17.ebuild,v 1.1 2003/08/01 16:13:39 foser Exp $

# since its a development version
inherit debug gnome.org

IUSE="gnome opengl"

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.daa.com.au/~james/pygtk/"
LICENSE="LGPL-2.1"

KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND=">=dev-lang/python-2.2
	>=x11-libs/pango-1
	>=x11-libs/gtk+-2
	>=dev-libs/atk-1
	>=dev-libs/glib-2
	gnome? ( >=gnome-base/libglade-2 )
	opengl? ( >=x11-libs/gtkglarea-1.99 )"

SLOT="2"

src_compile() {
	econf --enable-thread || die
	emake || die
}

src_install () {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog INSTALL MAPPING NEWS README THREADS TODO
}

pkg_postinst() {
	einfo 'If you built pygtk with OpenGL support you still need to emerge PyOpenGL to use it. '
}
