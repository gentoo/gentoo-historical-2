# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/file-roller/file-roller-2.2.1.ebuild,v 1.7 2003/02/22 03:41:36 agriffis Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="File Roller is an archive manager for the GNOME environment."
HOMEPAGE="http://fileroller.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc alpha"

DEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.1
	>=gnome-base/libgnome-2.1
	>=gnome-base/libgnomeui-2.1
	>=gnome-base/gnome-vfs-2.2	
	>=gnome-base/libglade-2	
	>=gnome-base/bonobo-activation-1
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2"

RDEPEND="${DEPEND}
	>=gnome-base/gconf-1.2
	>=app-text/scrollkeeper-0.3.11"

DOCS="AUTHORS COPYING ChangeLog NEWS README TODO"
