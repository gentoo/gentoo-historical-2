# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-misc/bidwatcher/bidwatcher-1.3.12.ebuild,v 1.2 2004/02/29 00:12:22

IUSE=""

MY_P=${P/_rc/-rc}
DESCRIPTION="eBay auction watcher and sniper agent"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://bidwatcher.sourceforge.net/"

KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/glibc
	=x11-libs/gtk+-1.2*
	=dev-libs/glib-1.2*"

S=${WORKDIR}/${MY_P}

src_install() {
	einstall || die
	dodoc README COPYING NEWS AUTHORS ChangeLog
	dohtml quick_start.html
}
