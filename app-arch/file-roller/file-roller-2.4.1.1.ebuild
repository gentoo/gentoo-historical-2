# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/file-roller/file-roller-2.4.1.1.ebuild,v 1.6 2004/02/08 21:47:48 spider Exp $

inherit gnome2

DESCRIPTION="Archive manager for GNOME"
HOMEPAGE="http://fileroller.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~alpha sparc hppa ~amd64"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.1
	>=gnome-base/libgnome-2.1
	>=gnome-base/libgnomeui-2.1
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/libglade-2
	>=gnome-base/libbonobo-2
	>=gnome-base/gconf-2.0
	>=gnome-base/libbonoboui-2.3"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=app-text/scrollkeeper-0.3.11"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
