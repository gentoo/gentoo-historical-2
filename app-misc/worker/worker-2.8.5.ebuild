# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

DESCRIPTION="Worker Filemanager: Amiga Directory Opus 4 clone"
HOMEPAGE="http://www.boomerangsworld.de/worker/"
SRC_URI="http://www.boomerangsworld.de/worker/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~ia64 ~sparc alpha ~hppa ~mips"
IUSE=""

DEPEND="virtual/x11"

src_install() {
	einstall || die
	doman man/worker.1
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README README_LARGEFILES THANKS
}
