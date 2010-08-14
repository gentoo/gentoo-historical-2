# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgsf/libgsf-1.14.18.ebuild,v 1.6 2010/08/14 16:49:42 armin76 Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools eutils gnome2 python multilib

DESCRIPTION="The GNOME Structured File Library"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI}
	mirror://gentoo/gnome-mplayer-0.9.6-gconf-2.m4.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ~ppc ~ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 doc gnome gtk python thumbnail"

RDEPEND="
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.4.16
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	gnome? (
		>=gnome-base/libbonobo-2
		>=gnome-base/gnome-vfs-2.2 )
	gtk? ( >=x11-libs/gtk+-2 )
	python? (
		>=dev-python/pygobject-2.10
		>=dev-python/pygtk-2.10 )
	thumbnail? ( >=gnome-base/gconf-2 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"

PDEPEND="gnome? ( || (
	media-gfx/imagemagick
	media-gfx/graphicsmagick[imagemagick] ) )"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-gio
		--disable-static
		$(use_with bzip2 bz2)
		$(use_with gnome gnome-vfs)
		$(use_with gnome bonobo)
		$(use_with python)
		$(use_with gtk gdk-pixbuf)
		$(use_with thumbnail gconf)"
}

src_prepare() {
	gnome2_src_prepare

	cp "${WORKDIR}/gnome-mplayer-0.9.6-gconf-2.m4" m4/ \
		|| die "failed to copy gconf macro"

	# Fix gconf automagic, bug #289856
	epatch "${FILESDIR}/${PN}-1.14.16-gconf-automagic.patch"

	# Fix useless variable in toplevel Makefile.am, bug #298813
	epatch "${FILESDIR}/${PN}-1.14.16-automake-fixes.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
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
