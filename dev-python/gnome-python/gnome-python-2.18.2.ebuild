# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python/gnome-python-2.18.2.ebuild,v 1.6 2007/08/10 13:11:56 angelos Exp $

inherit gnome2 python

DESCRIPTION="GNOME 2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ~ppc64 ~sh sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-lang/python-2.2
	>=dev-python/pygtk-2.10.3
	>=dev-python/pyorbit-2.0.1
	>=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	>=gnome-base/libgnome-2.8
	>=gnome-base/libgnomeui-2.8
	>=gnome-base/libgnomecanvas-2.8
	>=gnome-base/gnome-vfs-2.14.0
	>=gnome-base/gconf-2.11.1
	>=gnome-base/libbonobo-2.8
	>=gnome-base/libbonoboui-2.8"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

# Skip test, to avoid gnome-python-2.0 block (fixes bug 72594)
RESTRICT="test"
DOCS="AUTHORS ChangeLog NEWS"

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_install() {
	gnome2_src_install

	insinto /usr/share/doc/${PF}
	doins -r examples
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/gtk-2.0
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
