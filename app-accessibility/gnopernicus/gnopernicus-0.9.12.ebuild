# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/gnopernicus/gnopernicus-0.9.12.ebuild,v 1.6 2004/11/12 10:55:28 obz Exp $

inherit gnome2

DESCRIPTION="Software tools for blind and visually impaired in Gnome 2"
HOMEPAGE="http://www.baum.ro/gnopernicus.html"

LICENSE="LGPL-2"
SLOT="1"
KEYWORDS="x86 ppc sparc ~alpha ~hppa ~amd64 ~ia64 ~mips"
IUSE="brltty doc ipv6"

RDEPEND=">=gnome-base/gconf-1.1.5
	>=dev-libs/popt-1.5
	>=gnome-base/libgnome-1.102
	>=gnome-base/libgnomeui-1.106
	>=dev-libs/glib-1.3.12
	>=x11-libs/gtk+-1.3
	>=dev-libs/libxml2-2.4.6
	>=gnome-base/libglade-1.99.4
	>=gnome-extra/at-spi-1.3.11
	>=app-accessibility/gnome-speech-0.3
	>=app-accessibility/gnome-mag-0.11
	>=gnome-extra/libgail-gnome-1.0
	virtual/x11
	brltty? ( app-accessibility/brltty )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	dev-util/pkgconfig
	app-text/scrollkeeper
	doc? ( dev-util/gtk-doc )"

G2CONF="${G2CONF} --with-default-fonts-path=${D}/usr/share/fonts/default/Type1"
G2CONF="${G2CONF} $(use_enable ipv6) $(use_enable brltty)"

DOCS="AUTHORS ChangeLog NEWS README"

