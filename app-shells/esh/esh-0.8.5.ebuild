# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-shells/esh/esh-0.8.5.ebuild,v 1.2 2002/07/07 12:00:29 aliz Exp $

S=${WORKDIR}/esh
DESCRIPTION="A UNIX Shell with a simplified Scheme syntax"
SRC_URI="http://slon.ttk.ru/esh/${P}.tar.gz"
HOMEPAGE="http://slon.ttk.ru/esh/"
LICENSE="GPL-2"

DEPEND="virtual/glibc
		>=sys-libs/ncurses-5.1
		>=sys-libs/readline-4.1"

src_compile() {

	cp Makefile Makefile.orig
	sed -e "s:^CFLAGS=:CFLAGS=${CFLAGS/-fomit-frame-pointer/} :" \
		-e "s:^LIB=:LIB=-lncurses :" \
		-e "s:-ltermcap::" \
		Makefile.orig > Makefile
	make || die
}

src_install() {

	dobin esh
	into /usr
	doinfo doc/esh.info
	dodoc CHANGELOG CREDITS GC_README HEADER LICENSE READLNE-HACKS TODO
	dohtml doc/*.html
	docinto examples
	dodoc examples/*
	insinto /usr/share/emacs/site-lisp/
	doins emacs/esh-mode.el
}
