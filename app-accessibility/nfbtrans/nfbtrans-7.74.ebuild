# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/nfbtrans/nfbtrans-7.74.ebuild,v 1.1 2004/09/22 01:42:53 williamh Exp $

inherit eutils

DESCRIPTION="braille translator from the National Federation of the Blind"
HOMEPAGE="http://www.nfb.org/nfbtrans.htm"
SRC_URI="http://www.nfb.org/braille/nfbtrans/nfbtr774.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=app-arch/unzip-5.50-r2"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mv MAKEFILE Makefile
	mv SPANISH.ZIP spanish.zip
	make lowercase || die
	epatch ${FILESDIR}/${P}-gentoo-fix.patch
}

src_compile() {
	make LIBS= CFLAGS="${CFLAGS} -DLINUX" all || die
}

src_install() {
	dobin nfbtrans || die
	dodoc *fmt readme.txt makedoc
	insinto /etc/nfbtrans
	doins *cnf *tab *dic spell.dat *zip
}
