# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/deskbar-applet/deskbar-applet-2.24.3.ebuild,v 1.7 2009/03/18 15:39:34 armin76 Exp $

GCONF_DEBUG="no"

inherit autotools eutils gnome2 python

DESCRIPTION="An Omnipresent Versatile Search Interface"
HOMEPAGE="http://raphael.slinckx.net/deskbar/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="eds spell test"

RDEPEND=">=dev-lang/python-2.4
	>=x11-libs/gtk+-2.12
	>=dev-python/pygtk-2.12
	>=dev-python/pygobject-2.12
	>=gnome-base/gnome-desktop-2.10
	>=dev-python/dbus-python-0.80.2
	dev-python/gnome-desktop-python
	>=dev-python/gconf-python-2.22.1
	>=dev-python/gnome-vfs-python-2.22.1
	>=dev-python/libgnome-python-2.22.1
	>=dev-python/gnome-applets-python-2.22.0
	>=dev-python/libwnck-python-2.22.0
	>=gnome-base/gconf-2
	eds? ( >=gnome-extra/evolution-data-server-1.7.92 )
	spell? ( >=gnome-extra/gnome-utils-2.16.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.2 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable eds evolution)
		--exec-prefix=/usr
		--disable-scrollkeeper"
}

src_unpack() {
	gnome2_src_unpack

	# Fix installing libs into pythondir
	epatch "${FILESDIR}/${PN}-2.24.1-multilib.patch"

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# needed to build on a libtool-1 system, bug #243822
	rm m4/lt* m4/libtool.m4 ltmain.sh

	AT_M4DIR="m4" eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst

	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/deskbar
	python_mod_optimize /usr/$(get_libdir)/deskbar-applet/modules-2.20-compatible

	ebeep 5
	ewarn "The dictionary plugin in deskbar-applet uses the dictionary from "
	ewarn "gnome-extra/gnome-utils.  If it is not present, the dictionary "
	ewarn "plugin will fail silently."
	epause 5
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/deskbar
	python_mod_cleanup /usr/$(get_libdir)/deskbar-applet/modules-2.20-compatible
}
