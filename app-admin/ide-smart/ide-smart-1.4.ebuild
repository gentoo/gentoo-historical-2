# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/ide-smart/ide-smart-1.4.ebuild,v 1.16 2003/09/23 20:20:55 aliz Exp $

DESCRIPTION="A tool to read SMART information from harddiscs"
SRC_URI="http://lightside.eresmas.com/${P}.tar.gz"
HOMEPAGE="http://lightside.eresmas.com/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A} ; cd ${S}
	rm ide-smart ide-smart.o
	sed -i -e "s:^CFLAGS.*:CFLAGS = ${CFLAGS}:" \
		-e "s:^#CC.*:CC = gcc:" \
		Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin ide-smart
	doman ide-smart.8
	dodoc README COPYING
}
