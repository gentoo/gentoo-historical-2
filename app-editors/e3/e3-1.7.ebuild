# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: tools@gentoo.org
#
# NOTE: this is an x86-only ebuild!!!
#
# $Header: /var/cvsroot/gentoo-x86/app-editors/e3/e3-1.7.ebuild,v 1.1 2001/08/08 04:39:53 chadh Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Super Tiny Editor with wordstar, vi, and emacs key bindings"
SRC_URI="http://www.sax.de/~adlibit/${P}.tar.gz"
HOMEPAGE="http://www.sax.de/~adlibit"
DEPEND="dev-lang/nasm"
#RDEPEND=""

src_compile() {
	try emake
}

src_install () {
	dodir /usr/bin
	dobin e3 e3vi e3em e3ws e3pi e3ne

	cp e3.man e3.1
	doman e3.1
}

