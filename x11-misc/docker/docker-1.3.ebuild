# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header

S=${WORKDIR}/${P}
DESCRIPTION="Openbox app which acts as a system tray for KDE and GNOME2"
SRC_URI="http://icculus.org/openbox/docker/${P}.tar.gz"
HOMEPAGE="http://icculus.org/openbox/docker/"

DEPEND="x11-wm/openbox"
RDEPEND=${DEPEND}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

src_compile() {

	emake || die
	
}

src_install () {

	dobin docker
	dodoc COPYING README
}
