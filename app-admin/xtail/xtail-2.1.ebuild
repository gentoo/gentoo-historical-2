# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/xtail/xtail-2.1.ebuild,v 1.8 2002/10/20 18:14:57 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Tail multiple logfiles at once, even if rotated."
SRC_URI="http://www.unicom.com/sw/xtail/${P}.tar.gz"
HOMEPAGE="http://www.unicom.com/sw/xtail/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	doman xtail.1
	dobin xtail
	dodoc README
}
