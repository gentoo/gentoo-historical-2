# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/at-spi/at-spi-1.0.1.ebuild,v 1.2 2002/07/23 23:32:43 spider Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="This is the Gnome Accessibility Toolkit"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/at-spi/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86"

RDEPEND=">=gnome-base/gail-0.16
	>=gnome-base/libbonobo-2.0.0
	>=dev-libs/popt-1.6.3"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( dev-util/gtk-doc )"
		
DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"





