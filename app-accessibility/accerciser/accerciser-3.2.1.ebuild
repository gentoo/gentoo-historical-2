# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/accerciser/accerciser-3.2.1.ebuild,v 1.1 2011/11/20 22:52:16 eva Exp $

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.4"

inherit gnome2 python

DESCRIPTION="Interactive Python accessibility explorer"
HOMEPAGE="http://live.gnome.org/Accerciser"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-python/ipython
	>=dev-python/pygobject-2.90.3:3
	dev-python/librsvg-python
	>=dev-python/pyatspi-2.1.5
	dev-python/pycairo

	>=gnome-base/gconf-3:2[introspection]
	>=x11-libs/libwnck-3:3[introspection]
	>=gnome-extra/at-spi-2.1.5:2
	dev-libs/atk[introspection]
	>=dev-libs/glib-2.28:2
	x11-libs/gdk-pixbuf[introspection]
	>=x11-libs/gtk+-3.1.13:3[introspection]"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.17.3"

pkg_setup() {
	G2CONF="${G2CONF} --without-pyreqs"
	DOCS="AUTHORS COPYING ChangeLog NEWS README"
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile

	python_convert_shebangs -r 2 .
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_need_rebuild
	python_mod_optimize "${PN}"
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup "${PN}"
}
