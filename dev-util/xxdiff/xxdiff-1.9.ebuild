# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Michael Conrad Tilstra <michael@gentoo.org> <tadpol@tadpol.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/xxdiff/xxdiff-1.9.ebuild,v 1.3 2001/12/29 21:45:08 danarmak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A graphical file comparator and merge tool simular to xdiff."
SRC_URI="http://prdownloads.sourceforge.net/xxdiff/${P}.src.tar.gz"
HOMEPAGE="http://xxdiff.sourceforge.net/"

DEPEND="virtual/glibc
	>=x11-libs/qt-2.3.0
	>=sys-devel/gcc-2.95.3"

RDEPEND="sys-apps/diffutils"

src_compile() {
	QTDIR=/usr/qt/2 ./configure --prefix=/usr --mandir=/usr/share/man || die

	make || die
}

src_install () {
	dobin src/xxdiff
	newman src/xxdiff.man xxdiff.1
	dodoc README COPYING CHANGES ChangeLog 
	dodoc copyright.txt doc/xxdiff-doc.sgml
}

# vim: ai et sw=4 ts=4
