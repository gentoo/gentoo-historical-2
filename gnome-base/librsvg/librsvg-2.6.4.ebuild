# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/librsvg/librsvg-2.6.4.ebuild,v 1.4 2004/05/20 23:53:33 foser Exp $

inherit eutils gnome2

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="http://librsvg.sourceforge.net/"

IUSE="doc zlib"
SLOT="2"
KEYWORDS="x86 ~ppc ~alpha ~sparc ~hppa ~amd64 ~ia64 ~mips"
LICENSE="LGPL-2"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2
	>=media-libs/libart_lgpl-2.3.10
	>=dev-libs/libxml2-2.4.7
	>=x11-libs/pango-1.2
	>=dev-libs/popt-1.5
	>=dev-libs/libcroco-0.4
	zlib? ( >=gnome-extra/libgsf-1.6 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12
	doc? ( >=dev-util/gtk-doc-0.9 )"

# FIXME : USEify croco support (?)
G2CONF="${G2CONF} $(use_with zlib svgz) \
	--with-croco \
	--enable-pixbuf-loader \
	--enable-gtk-theme"

DOCS="AUTHORS ChangeLog COPYIN* README INSTALL NEWS TODO"

src_unpack () {
	unpack ${A}
	cd ${S}
	# Make sure the source is proper ANSI C, so it compiles with gcc-2.
	epatch ${FILESDIR}/${P}-gcc2_fix.patch
}

src_install() {

	gnome2_src_install

	# remove gdk-pixbuf loaders (#47766)
	rm -fr ${D}/etc

}

pkg_postinst() {

	gdk-pixbuf-query-loaders > /etc/gtk-2.0/gdk-pixbuf.loaders

}

pkg_postrm() {

	gdk-pixbuf-query-loaders > /etc/gtk-2.0/gdk-pixbuf.loaders

}
