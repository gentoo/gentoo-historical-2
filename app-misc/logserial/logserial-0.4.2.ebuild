# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/logserial/logserial-0.4.2.ebuild,v 1.2 2005/01/01 15:12:56 eradicator Exp $

DESCRIPTION="A tool for logging raw data from a serial device."
HOMEPAGE="http://www.gtlib.cc.gatech.edu/pub/Linux/system/serial/logserial-0.4.2.lsm"
SRC_URI="http://www.gtlib.cc.gatech.edu/pub/Linux/system/serial/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

src_install() {
	dodir /usr/bin
	cp logserial ${D}/usr/bin
}
