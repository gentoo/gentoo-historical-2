# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libbonoboui/libbonoboui-2.0.1.ebuild,v 1.6 2002/12/09 04:22:38 manson Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="User Interface part of Lib bonobo"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc  alpha"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND=">=dev-libs/glib-2.0.6
	>=x11-libs/gtk+-2.0.6
	>=gnome-base/bonobo-activation-1.0.3
	>=gnome-base/libbonobo-2.0.0
	>=gnome-base/libglade-2.0.0
	>=media-libs/libart_lgpl-2.3.10
	>=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomecanvas-2.0.0
	>=gnome-base/gconf-1.2.1"


DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.17"


LIBTOOL_FIX="0"
DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"





