# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.8.3.ebuild,v 1.5 2005/05/11 13:23:26 gmsoft Exp $

inherit eutils gnome2

DESCRIPTION="A text editor for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ~mips ppc ~ppc64 ~sparc x86"
IUSE="spell"

RDEPEND=">=gnome-base/libglade-2.3.6
	>=dev-libs/popt-1.5
	>=gnome-base/eel-2.6
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2.8
	>=gnome-base/libgnomeprintui-2.6
	>=x11-libs/gtksourceview-1.1.1
	spell? ( virtual/aspell-dict )"
# FIXME : spell autodetect only

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.31"

DOCS="AUTHORS BUGS ChangeLog README THANKS TODO"

