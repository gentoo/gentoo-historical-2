# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/at-spi/at-spi-1.0.2.ebuild,v 1.10 2004/02/03 10:32:27 ferringb Exp $

IUSE="doc"

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="This is the Gnome Accessibility Toolkit"
SRC_URI="mirror://gnome/2.0.1/sources/at-spi/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc hppa amd64 sparc"

RDEPEND=">=gnome-base/gail-0.17
	>=gnome-base/libbonobo-2.0.0
	>=dev-libs/popt-1.6.3"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( dev-util/gtk-doc )
	dev-perl/XML-Parser"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"





