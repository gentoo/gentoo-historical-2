# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xtermcontrol/xtermcontrol-2.4.ebuild,v 1.1 2004/05/20 13:28:36 pfeifer Exp $

IUSE=""

DESCRIPTION="xtermcontrol enables dynamic control of XFree86 xterm properties."
SRC_URI="http://www.thrysoee.dk/xtermcontrol/${P}.tar.gz"
HOMEPAGE="http://www.thrysoee.dk/xtermcontrol/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 -*"

DEPEND="virtual/x11"


src_compile() {
	econf || die "econf failed"

	emake || die
}

src_install () {
	einstall || die
}
