# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libbonoboui/libbonoboui-2.0.3.2.ebuild,v 1.1 2002/10/27 18:56:43 foser Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="User Interface part of Lib bonobo"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND=">=x11-libs/gtk+-2.0.2
	>=gnome-base/bonobo-activation-1
	>=gnome-base/libbonobo-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/gconf-1.2.1"


DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.22"

LIBTOOL_FIX="0"
DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"

