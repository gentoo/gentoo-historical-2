# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Bart Lauwers <blauwers@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ext2resize/ext2resize-1.1.17.ebuild,v 1.2 2002/07/10 16:17:57 aliz Exp $

DESCRIPTION="EXT2 and EXT3 filesystem resizing utilities"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://ext2resize.sourceforge.net/"
LICENSE="GPL-2"

DEPEND="virtual/glibc"
	
src_compile() {
	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info || die
		
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
