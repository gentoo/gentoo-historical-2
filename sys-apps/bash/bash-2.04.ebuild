# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/bash/bash-2.04.ebuild,v 1.3 2000/09/21 23:08:39 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The standard GNU Bourne again shell"
SRC_URI="ftp://ftp.gnu.org/gnu/bash/"${A}
HOMEPAGE="http://www.gnu.org/software/bash/bash.html"

src_compile() {                           

	cd ${S}
	try ./configure --prefix=/ --enable-static-link --disable-profiling --with-curses --host=${CHOST}
	try make

}



src_install() {    
                           
	cd ${S}
	cp doc/bashref.info doc/bash.info
	into /usr
	doinfo doc/bash.info
	doman doc/*.1
	into /
	dobin bash bashbug
	dosym bash /bin/sh
	dodoc README NEWS AUTHORS CHANGES COMPAT COPYING Y2K doc/FAQ doc/INTRO

}

