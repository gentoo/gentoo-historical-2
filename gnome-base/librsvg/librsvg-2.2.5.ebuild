# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/librsvg/librsvg-2.2.5.ebuild,v 1.7 2003/08/23 17:44:31 foser Exp $

inherit gnome2

IUSE="doc"
DESCRIPTION="rendering svg library"
HOMEPAGE="http://www.gnome.org/"
SLOT="2"
KEYWORDS="x86 ppc ~alpha sparc hppa amd64"
LICENSE="GPL-2 LGPL-2"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2
	>=media-libs/libart_lgpl-2.3.10
	>=dev-libs/libxml2-2.4.7
	>=x11-libs/pango-1.1
	>=dev-libs/popt-1.5
	>=gnome-extra/libgsf-1.6.0"

DEPEND="${RDEPEND} 
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9 )"
	
DOCS="AUTHORS ChangeLog COPYIN* README INSTALL NEWS TODO"

pkg_postinst() {
 
        gdk-pixbuf-query-loaders > /etc/gtk-2.0/gdk-pixbuf.loaders
 
}
 
pkg_postrm() {
 
        gdk-pixbuf-query-loaders > /etc/gtk-2.0/gdk-pixbuf.loaders
 
}

