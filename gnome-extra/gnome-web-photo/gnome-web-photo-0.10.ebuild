# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-web-photo/gnome-web-photo-0.10.ebuild,v 1.2 2011/03/21 23:30:20 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="a tool to generate images and thumbnails from HTML files"
HOMEPAGE="ftp://ftp.gnome.org/pub/gnome/sources/gnome-web-photo"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.14:2
	>=x11-libs/gtk+-2.20:2
	>=dev-libs/libxml2-2.6.12:2
	media-libs/libpng
	gnome-base/gconf:2
	>=net-libs/webkit-gtk-1.1.23:2
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35
	sys-devel/gettext"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"
	G2CONF="${G2CONF} --with-gtk=2.0"
}
