# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gawk/gawk-3.0.6-r2.ebuild,v 1.1 2001/02/07 15:51:27 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="GNU awk pattern-matching language"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/gawk/${A}
	 ftp://prep.ai.mit.edu/gnu/gawk/${A}"
HOMEPAGE="http://www.gnu.org/software/gawk/gawk.html"
DEPEND="virtual/glibc"

src_compile() {

	try ./configure --prefix=/usr --libexecdir=/usr/lib/awk --mandir=/usr/share/man --infodir=/usr/share/info --host=${CHOST}
	try make ${MAKEOPTS}

}

src_install() {

	try make prefix=${D}/usr mandir=${D}/usr/share/man/man1 infodir=${D}/usr/share/info libexecdir=${D}/usr/lib/awk install

        dodoc ChangeLog ACKNOWLEDGMENT COPYING FUTURES
	dodoc LIMITATIONS NEWS PROBLEMS README
	docinto README_d
	dodoc README_d/*
	docinto atari
	dodoc atari/ChangeLog atari/README.1st
	docinto awklib
	dodoc awklib/ChangeLog
	docinto pc
	dodoc pc/ChangeLog
	docinto posix
	dodoc posix/ChangeLog

}



