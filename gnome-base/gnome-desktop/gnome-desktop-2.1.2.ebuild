# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-desktop/gnome-desktop-2.1.2.ebuild,v 1.1 2002/11/13 00:25:15 foser Exp $

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="Libraries for the gnome desktop that is not part of the UI"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
KEYWORDS="x86 ppc sparc sparc64 alpha"
LICENSE="GPL-2 FDL-1.1 LGPL-2.1"

RDEPEND="=gnome-base/libgnomeui-2.1*
	=gnome-base/libgnomecanvas-2.1*
	=x11-libs/gtk+-2.1*
	=gnome-base/gnome-vfs-2.1*
	!gnome-base/gnome-core"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.22
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog COPYING*  README* INSTALL NEWS HACKING"


