# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-build/bash/bash-2.04-r1.ebuild,v 1.2 2001/02/01 19:30:33 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The standard GNU Bourne again shell"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/bash/${A}
	 ftp://ftp.gnu.org/gnu/bash/${A}"

HOMEPAGE="http://www.gnu.org/software/bash/bash.html"

PROVIDE="virtual/bash"

src_compile() {                           

	cd ${S}
        echo $THOST
	try ./configure --prefix=/  --build=${CHOST} --target=${THOST} \
		--disable-profiling --with-curses \
		--enable-static-link --disable-nls
	cp Makefile Makefile.orig
	sed -e "s:-lcurses:-lncurses:" Makefile.orig > Makefile
	try pmake
}



src_install() {
	cd ${S}
	make prefix=${D}/usr install
	dodir /bin
	mv ${D}/usr/bin/bash ${D}/bin
	dosym bash /bin/sh
        rm -rf ${D}/usr
}

