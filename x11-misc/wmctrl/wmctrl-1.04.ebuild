# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wmctrl/wmctrl-1.04.ebuild,v 1.7 2005/02/20 10:42:49 usata Exp $

IUSE=""

DESCRIPTION="command line tool to interact with an EWMH/NetWM compatible X Window Manager"
HOMEPAGE="http://sweb.cz/tripie/utils/wmctrl/"
SRC_URI="http://sweb.cz/tripie/utils/wmctrl/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc"

DEPEND="virtual/x11"

src_install () {
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
	make DESTDIR=${D} install || die
}
