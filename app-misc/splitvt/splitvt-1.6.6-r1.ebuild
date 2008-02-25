# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/splitvt/splitvt-1.6.6-r1.ebuild,v 1.1 2008/02/25 08:14:57 pva Exp $

inherit eutils toolchain-funcs

MY_P="${P/-/_}"
DEB_PL="4"

DESCRIPTION="A program for splitting terminals into two shells"
HOMEPAGE="http://www.devolution.com/~slouken/projects/splitvt"
SRC_URI="http://www.devolution.com/~slouken/projects/${PN}/${P}.tar.gz
	mirror://debian/pool/main/s/splitvt/${MY_P}-${DEB_PL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${MY_P}-${DEB_PL}.diff
	sed -i -e "s:/usr/local/bin:${D}/usr/bin:g" \
		-e "s:/usr/local/man/:${D}/usr/share/man/:g" config.c
}

src_compile() {
	# upstream has their own weirdo configure script...
	./configure || die "configure failed"
	sed -i -e "s:-O2:${CFLAGS}:" -e "s:^CC = gcc:CC = $(tc-getCC):" Makefile
	emake || die "emake failed"
}

src_install() {
	dodir /usr/bin /usr/share/man/man1/
	make install || die "make install failed"
	fperms 755 /usr/bin/xsplitvt
	dodoc ANNOUNCE BLURB CHANGES NOTES README TODO
	doman splitvt.1
}
