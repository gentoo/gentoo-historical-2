# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/expat/expat-1.95.5-r1.ebuild,v 1.14 2005/01/11 21:18:17 vapier Exp $

DESCRIPTION="XML parsing libraries"
SRC_URI="mirror://sourceforge/expat/${P}.tar.gz"
HOMEPAGE="http://expat.sourceforge.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf || die
	# parallel make doesnt work
	make || die
}

src_install() {
	einstall mandir=${D}/usr/share/man/man1
	dodoc COPYING Changes MANIFEST README
	dohtml doc/*
}
