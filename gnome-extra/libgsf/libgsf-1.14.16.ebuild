# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgsf/libgsf-1.14.16.ebuild,v 1.2 2009/12/27 04:07:52 nirbheek Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools eutils gnome2 python multilib

DESCRIPTION="The GNOME Structured File Library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="bzip2 doc gnome gtk python"

RDEPEND="
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.4.16
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	gnome? (
		>=gnome-base/gconf-2
		>=gnome-base/libbonobo-2 )
	gtk? ( >=x11-libs/gtk+-2 )
	python? (
		>=dev-python/pygobject-2.10
		>=dev-python/pygtk-2.10 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0
	doc? ( >=dev-util/gtk-doc-1 )"

PDEPEND="gnome? ( media-gfx/imagemagick )"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-gio
		--disable-static
		$(use_with bzip2 bz2)
		$(use_with gnome gconf)
		$(use_with gnome bonobo)
		$(use_with python)
		$(use_with gtk gdk-pixbuf)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix gconf automagic, bug 289856
	epatch "${FILESDIR}/${P}-gconf-automagic.patch"

	eautoreconf

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_preinst() {
	gnome2_pkg_preinst
	preserve_old_lib /usr/$(get_libdir)/libgsf-1.so.1
	preserve_old_lib /usr/$(get_libdir)/libgsf-gnome-1.so.1
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_need_rebuild
		python_mod_optimize $(python_get_sitedir)/gsf
	fi

	preserve_old_lib_notify /usr/$(get_libdir)/libgsf-1.so.1
	preserve_old_lib_notify /usr/$(get_libdir)/libgsf-gnome-1.so.1
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/gsf
}
