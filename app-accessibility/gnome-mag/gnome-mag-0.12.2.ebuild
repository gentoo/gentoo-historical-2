# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/gnome-mag/gnome-mag-0.12.2.ebuild,v 1.6 2006/01/22 20:14:11 dang Exp $

inherit gnome2

DESCRIPTION="Gnome magnification service definition"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="1"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-1.3.11
	>=x11-libs/gtk+-2.1
	>=gnome-base/libbonobo-1.107
	>=gnome-extra/at-spi-1.5.2
	>=gnome-base/orbit-2.3.100
	dev-libs/popt
	virtual/x11"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.28"

DOCS="AUTHORS ChangeLog NEWS README"
