# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/worker/worker-2.11.1.ebuild,v 1.6 2006/07/27 15:10:39 deltacow Exp $

DESCRIPTION="Worker Filemanager: Amiga Directory Opus 4 clone"
HOMEPAGE="http://www.boomerangsworld.de/worker/"
SRC_URI="http://www.boomerangsworld.de/worker/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ~mips ppc sparc x86"
IUSE=""

DEPEND="|| ( x11-libs/libSM virtual/x11 )"

src_install() {
	einstall || die "make install failed"
	doman man/worker.1
	dodoc AUTHORS ChangeLog INSTALL NEWS README README_LARGEFILES THANKS
}
