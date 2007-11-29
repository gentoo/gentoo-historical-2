# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/librsvg/librsvg-2.18.2.ebuild,v 1.7 2007/11/29 05:23:52 jer Exp $

inherit gnome2 multilib

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="http://librsvg.sourceforge.net/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="doc gnome zlib"

RDEPEND="
	>=media-libs/fontconfig-1.0.1
	>=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.12
	>=dev-libs/libxml2-2.4.7
	>=x11-libs/cairo-1.2
	>=x11-libs/pango-1.2
	>=media-libs/freetype-2
	zlib? ( >=gnome-extra/libgsf-1.6 )
	>=dev-libs/libcroco-0.6.1
	gnome? (
		>=gnome-base/gnome-vfs-2
		>=gnome-base/libgnomeprint-2.2
		>=gnome-base/libgnomeprintui-2.2
	)"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12
	doc? ( >=dev-util/gtk-doc-1 )"

# FIXME: USEify croco support (?)
G2CONF="${G2CONF} \
	$(use_with zlib svgz) \
	$(use_enable gnome gnome-vfs) \
	$(use_enable gnome gnome-print) \
	--disable-mozilla-plugin --with-croco \
	--enable-pixbuf-loader \
	--enable-gtk-theme"

DOCS="AUTHORS ChangeLog README NEWS TODO"

set_gtk_confdir() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0}
}

src_install() {
	gnome2_src_install

	# remove gdk-pixbuf loaders (#47766)
	rm -fr "${D}/etc"
}

pkg_postinst() {
	set_gtk_confdir
	gdk-pixbuf-query-loaders > ${GTK2_CONFDIR}/gdk-pixbuf.loaders
}

pkg_postrm() {
	set_gtk_confdir
	gdk-pixbuf-query-loaders > ${GTK2_CONFDIR}/gdk-pixbuf.loaders
}
