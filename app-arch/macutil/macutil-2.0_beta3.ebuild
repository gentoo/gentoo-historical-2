# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/macutil/macutil-2.0_beta3.ebuild,v 1.18 2010/04/06 05:58:16 abcd Exp $

EAPI="3"

inherit eutils toolchain-funcs

MY_P=${P/_beta/b}
DESCRIPTION="A collection of programs to handle Macintosh files/archives on non-Macintosh systems"
HOMEPAGE="http://homepages.cwi.nl/~dik/english/ftp.html"
SRC_URI="ftp://ftp.cwi.nl/pub/dik/${MY_P/-/}.shar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~hppa ppc x86 ~x86-interix ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	gzip -dc "${DISTDIR}"/${A} | ${EPREFIX}/bin/sh
	assert
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch

	sed -i.orig \
		-e "s:-DBSD::g" \
		-e "s:-DDEBUG::g" \
		-e "s:/ufs/dik/tmpbin:${ED}/usr/bin:g" \
		makefile || die "sed makefile failed"

	sed -i \
		-e '/^CFLAGS =/s:= -O:+=:' \
		-e '/(OBJ/s:CFLAGS:LDFLAGS:' \
		*/makefile || die "sed makefile [2] failed"

	sed -i \
		-e '/-o makecrc/s:cc -O:$(CC) $(LDFLAGS):' \
		crc/makefile || die "sed makefile [3] failed"
}

src_configure() { :; }

src_compile() {
	emake CC="$(tc-getCC)" || die "build failed"
}

src_install() {
	dodir /usr/bin
	einstall || die "install failed"

	doman man/*.1
	dodoc README doc/*
}
