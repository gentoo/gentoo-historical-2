# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbdate/bbdate-0.2.4.ebuild,v 1.6 2004/06/06 23:31:02 weeve Exp $

IUSE=""
DESCRIPTION="blackbox date display"
SRC_URI="http://bbtools.windsofstorm.net/sources/${P}.tar.gz"
HOMEPAGE="http://bbtools.windsofstorm.net/available.phtml"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc"

DEPEND="virtual/blackbox"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README COPYING AUTHORS BUGS INSTALL ChangeLog NEWS TODO data/README.bbsload
}
