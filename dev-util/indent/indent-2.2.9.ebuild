# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/indent/indent-2.2.9.ebuild,v 1.15 2004/07/01 18:53:41 tgall Exp $

DESCRIPTION="Indent program source files"
HOMEPAGE="http://www.gnu.org/software/indent/indent.html"
SRC_URI="mirror://gnu/indent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64 mips s390 ppc64"

DEPEND="virtual/glibc"

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS COPYING NEWS README*
	dodoc ${D}/usr/doc/indent/*
	rm -rf ${D}/usr/doc
}
