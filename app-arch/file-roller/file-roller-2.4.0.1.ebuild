# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/file-roller/file-roller-2.4.0.1.ebuild,v 1.6 2003/11/08 12:51:24 todd Exp $

inherit gnome2

DESCRIPTION="archive manager for GNOME"
HOMEPAGE="http://fileroller.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha sparc ~hppa amd64"

DEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.1
	>=gnome-base/libgnome-2.1
	>=gnome-base/libgnomeui-2.1
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/libglade-2
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2.3"

RDEPEND="${DEPEND}
	dev-util/pkgconfig
	>=gnome-base/gconf-2.0
	>=app-text/scrollkeeper-0.3.11"

DOCS="AUTHORS ChangeLog NEWS README TODO"
