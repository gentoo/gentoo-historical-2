# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/zenity/zenity-1.8.ebuild,v 1.4 2004/02/10 14:04:21 gustavoz Exp $

inherit gnome2

DESCRIPTION="commandline dialog tool for gnome"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~alpha sparc hppa ~amd64 ~ia64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomecanvas-2
	dev-libs/popt"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.21
	app-text/scrollkeeper
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog HACKING INSTALL NEWS README THANKS TODO"
