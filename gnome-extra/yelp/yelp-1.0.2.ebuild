# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-1.0.2.ebuild,v 1.1 2002/08/05 21:35:38 spider Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Yelp is a Help browser for Gnome2"
SRC_URI="mirror://gnome/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 ppc"

RDEPEND=">=gnome-base/ORBit2-2.4.1
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libgnome-2.0.2
	>=gnome-base/gnome-vfs-2.0.2
	>=gnome-base/libbonobo-2.0.0
	>=gnome-extra/libgtkhtml-2.0.1
	>=dev-libs/libxslt-1.0.15"
	

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.12.0"


G2CONF="${G2CONF} --enable-platform-gnome-2"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
