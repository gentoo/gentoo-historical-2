# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/eject/eject-2.0.6.ebuild,v 1.10 2002/10/20 18:54:50 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A command to eject a disc from the CD-ROM drive"
SRC_URI="http://www.ibiblio.org/pub/Linux/utils/disk-management/${P}.tar.gz
	 http://www2.cddc.vt.edu/linux/utils/disk-management/${P}.tar.gz"
HOMEPAGE="http://www.pobox.com/~tranter/eject.html"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_compile() {
	./configure --prefix=/usr \
		--mandir=/usr/share/man || die
	make || die
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	make DESTDIR=${D} install || die
	dodoc ChangeLog COPYING README PORTING TODO 
	dodoc AUTHORS NEWS PROBLEMS
}
