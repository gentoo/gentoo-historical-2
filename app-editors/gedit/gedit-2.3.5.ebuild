# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.3.5.ebuild,v 1.4 2003/09/08 15:19:07 spider Exp $

inherit gnome2

IUSE="spell"
DESCRIPTION="A text editor for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa ~amd64"

RDEPEND=">=gnome-base/libglade-2
	>=dev-libs/popt-1.5
	>=gnome-base/eel-2.3
	>=gnome-base/libgnomeui-2.3
	>=gnome-base/libbonobo-2.3
	>=gnome-base/libgnomeprintui-2.3.1
	>=x11-libs/gtksourceview-0.2.1
	spell? ( virtual/aspell-dict )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.22"

DOCS="AUTHORS BUGS ChangeLog COPYING INSTALL NEWS README THANKS TODO"
