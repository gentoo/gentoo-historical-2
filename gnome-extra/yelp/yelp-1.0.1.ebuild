# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-1.0.1.ebuild,v 1.8 2002/10/04 05:40:02 vapier Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Yelp is a Help browser for Gnome2"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

RDEPEND=">=gnome-base/ORBit2-2.4.0
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libgnome-2.0.1
	>=gnome-base/gnome-vfs-2.0.0
	>=gnome-base/libbonobo-2.0.0
	>=gnome-extra/libgtkhtml-2.0.0
	>=dev-libs/libxslt-1.0.15"
	

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.12.0"


G2CONF="${G2CONF} --enable-platform-gnome-2"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
