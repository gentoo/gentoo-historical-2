# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnomeradio/gnomeradio-1.3.ebuild,v 1.3 2003/02/13 13:12:31 vapier Exp $ 

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="A GNOME2 radio tuner"
SRC_URI="http://mfcn.ilo.de/gnomeradio/${P}.tar.gz"
HOMEPAGE="http://mfcn.ilo.de/gnomeradio/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=gnome-base/libgnomeui-2
	>=gnome-base/gconf-1.2"

RDEPEND="${DEPEND} >=dev-util/pkgconfig-0.12.0"
G2CONF="${G2CONF} --enable-platform-gnome-2"

DOCS="ABOUT-NLS AUTHORS ChangeLog COPYING README* INSTALL NEWS TODO"

