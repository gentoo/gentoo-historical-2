# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/gnome-mag/gnome-mag-0.12.0.ebuild,v 1.4 2005/05/16 20:55:32 gustavoz Exp $

inherit gnome2

DESCRIPTION="Gnome magnification service definition"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="1"
KEYWORDS="x86 ~ppc sparc ~mips ~alpha ~hppa ~amd64 ~ia64 ~ppc64"
IUSE="static"

RDEPEND=">=gnome-base/libbonobo-1.107
	>=gnome-base/orbit-2.3.100
	>=gnome-extra/at-spi-1.5.2
	>=dev-libs/glib-1.3.11
	>=x11-libs/gtk+-2.1
	dev-libs/popt
	virtual/x11"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README"

G2CONF="${G2CONF} $(use_enable static)"
