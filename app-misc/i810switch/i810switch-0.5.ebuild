# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/i810switch/i810switch-0.5.ebuild,v 1.2 2003/10/09 01:35:01 hillster Exp $

DESCRIPTION="A utility for switching the LCD and external VGA displays on and off"
HOMEPAGE="http://vorlon.ces.cwru.edu/~ames/i810switch/"
SRC_URI="http://vorlon.ces.cwru.edu/~ames/i810switch/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha -arm -hppa -mips -sparc x86"
IUSE=""
DEPEND="virtual/glibc"
RDEPEND="sys-apps/pciutils"

src_compile()
{
	emake || die "compile failed"
}

src_install()
{
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog README TODO
}
