# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/mzscheme/mzscheme-103_pre1.ebuild,v 1.1 2002/02/17 21:47:26 karltk Exp $

S=${WORKDIR}/plt
DESCRIPTION="MzScheme scheme compiler"
SRC_URI="http://www.cs.rice.edu/CS/PLT/packages/download/103p1/mzscheme/mzscheme.src.unix.tar.gz"
HOMEPAGE="http://www.cs.rice.edu/CS/PLT/packages/mzscheme/"

DEPEND=""
#RDEPEND=""

src_compile() {
	cd src
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	cd src
	make DESTDIR=${D} install || die

	cd ${S}
	dodir /usr/share/mzscheme
	dobin bin/*
	cp -dpR collects/* ${D}/usr/share/mzscheme

	doman man/man1/*

	dodoc notes/COPYING.LIB
	dodoc README

	exeinto /usr/bin
	newexe src/mzscheme/mzscheme mzscheme-bin

	echo "#! /bin/sh" > ${D}/usr/bin/mzc
	echo '/usr/bin/mzscheme-bin -mqvL start.ss compiler -- ${1+"$@"}' >> ${D}/usr/bin/mzc

	echo "#! /bin/sh" > ${D}/usr/bin/mzscheme
	echo '/usr/bin/mzscheme-bin ${1+"$@"}' >> ${D}/usr/bin/mzscheme

	rm ${D}/usr/bin/{archsys,setup-plt}
}
