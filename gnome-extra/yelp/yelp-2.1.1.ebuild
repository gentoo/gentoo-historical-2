# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.1.1.ebuild,v 1.1 2002/10/28 14:44:57 foser Exp $

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="Yelp is a Help browser for Gnome2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64 ppc alpha"

RDEPEND=">=gnome-base/ORBit2-2.4.3
	>=dev-libs/glib-2
	=gnome-base/libgnomeui-2.1*
	=gnome-base/libgnome-2.1*
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libbonobo-2.0.0
	=gnome-extra/libgtkhtml-2.1*
	>=dev-libs/libxslt-1.0.20
	>=gnome-base/gconf-1.2
	>=gnome-extra/libgtkhtml-2.1.1"
	

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.12.0"


G2CONF="${G2CONF} --enable-platform-gnome-2"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
