# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/antiword/antiword-0.32.ebuild,v 1.8 2002/10/17 14:31:19 aliz Exp $

S=${WORKDIR}/${PN}.0.32
DESCRIPTION="Antiword is a free MS Word reader for Linux and RISC OS"
SRC_URI="http://www.winfield.demon.nl/linux/${P}.tar.gz"
HOMEPAGE="http://www.winfield.demon.nl"

DEPEND="app-text/ghostscript
	"
IUSE="kde"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

src_unpack() {
	unpack ${A}
	
	cd ${S}
	patch -p0 < ${FILESDIR}/gentoo-antiword.diff

	rm Makefile

	sed -e '/pedantic/d' -e 's/$(CFLAGS)/$(CFLAGS) -D$(DB)/' \
		Makefile.Linux > Makefile
}

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/bin
	doexe antiword

	if [`use kde`]
	then
		kantiword
	fi

	cd Docs
	doman antiword.1
	dodoc COPYING ChangeLog FAQ History Netscape QandA ReadMe

	cd ..
	insinto /usr/share/${PN}
	doins Resources/*
}
