# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/clisp/clisp-2.29.ebuild,v 1.10 2005/01/02 07:33:19 mkennedy Exp $

DESCRIPTION="A portable, bytecode-compiled implementation of Common Lisp"
HOMEPAGE="http://clisp.sourceforge.net/"
SRC_URI="http://cvs2.cons.org/ftp-area/clisp/source/latest/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="x86 ~ppc"
IUSE="X"

DEPEND="X? ( virtual/x11 )"

S=${WORKDIR}/${PN}

src_compile() {
	local myconf="--with-dynamic-ffi --with-dynamic-modules --with-export-syscalls --with-module=wildcard --with-module=regexp --with-module=bindings/linuxlibc6"
	use X && myconf="${myconf} --with-module=clx/new-clx"

	# compilation of modules fails if we don't do this (mkennedy: yep
	# -- confirmed on gcc3.2 too)

	unset CHOST
	unset CFLAGS
	unset CXXFLAGS

	./configure --prefix=/usr ${myconf} || die "./configure failed"
	cd src
	./makemake ${myconf} > Makefile
	make config.lisp

	# 2002-09-26: karltk
	# Not emake-safe
	make || die
}

src_install() {
	cd src
	make DESTDIR=${D} prefix=/usr install-bin || die
	doman clisp.1 clreadline.3
	dodoc SUMMARY README* NEWS MAGIC.add ANNOUNCE clisp.dvi clisp.html clreadline.dvi clreadline.html
}
