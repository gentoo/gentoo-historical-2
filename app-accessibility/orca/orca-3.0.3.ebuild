# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/orca/orca-3.0.3.ebuild,v 1.1 2011/08/16 13:11:31 nirbheek Exp $

EAPI="3"
GNOME_TARBALL_SUFFIX="xz"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.6"
# FIXME: multiple python support

inherit gnome2 python

DESCRIPTION="Extensible screen reader that provides access to the desktop"
HOMEPAGE="http://projects.gnome.org/orca/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

# liblouis is not in portage yet
# it is used to provide contracted braille support
# XXX: Check deps for correctness
RDEPEND=">=dev-libs/glib-2.10:2
	>=gnome-extra/at-spi-1.32:1
	>=gnome-base/orbit-2:2
	>=dev-python/pyorbit-2.24
	>=gnome-base/libbonobo-2.24
	>=dev-python/libbonobo-python-2.24:2

	dev-python/pygobject:2
	dev-python/pycairo
	dev-python/pyxdg
	>=dev-python/dbus-python-0.83
	>=dev-python/pygtk-2.12:2

	>=dev-python/libwnck-python-2.24
	>=dev-python/gconf-python-2.24:2
	>=dev-python/libgnome-python-2.14:2

	>=app-accessibility/gnome-speech-0.3.10:1
	>=app-accessibility/gnome-mag-0.12.5:1"

DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"
	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_configure() {
	# FIXME: Workaround for bug #325611 until root cause is found
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	# Needed for import pyatspi
	unset DBUS_SESSION_BUS_ADDRESS
	PYTHON="$(PYTHON)" gnome2_src_configure
}

src_compile() {
	# FIXME: Workaround for bug #325611 until root cause is found
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize "${PN}"
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup "${PN}"
}
