# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/elph/elph-0.1.5.ebuild,v 1.4 2005/01/30 20:46:57 j4rg0n Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Estimated Locations of Pattern Hits - Motif finder program"
HOMEPAGE="http://www.tigr.org/software/ELPH/index.shtml"
SRC_URI="ftp://ftp.tigr.org/pub/software/ELPH/ELPH-${PV}.tar.gz"
LICENSE="Artistic"

SLOT="0"
KEYWORDS="~x86 ~ppc-macos"
IUSE=""

S="${WORKDIR}/ELPH/sources"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-usage.patch
	sed -i -e "s/CC      := g++/CC      := $(tc-getCXX)/" \
		-e "s/-fno-exceptions -fno-rtti -D_REENTRANT -g/${CXXFLAGS}/" \
		-e "s/LINKER    := g++/LINKER    := $(tc-getCXX)/" \
		Makefile || die
}

src_compile() {
	make || die
}

src_install() {
	dobin elph
	cd ${WORKDIR}/ELPH
	dodoc VERSION
	newdoc Readme.ELPH README
}
