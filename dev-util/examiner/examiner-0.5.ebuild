# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/examiner/examiner-0.5.ebuild,v 1.7 2004/06/11 08:53:15 dholm Exp $

DESCRIPTION="Examiner is an application that utilizes the objdump command to disassemble and comment foreign executable binaries"
HOMEPAGE="http://www.academicunderground.org/examiner/"
SRC_URI="http://www.academicunderground.org/examiner/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

DEPEND="dev-lang/perl"

src_install() {

	dodir /usr/bin /usr/share/examiner /usr/share/man/man1
	dodir /usr/share/doc/examiner-0.5

	make MAN=${D}/usr/share/man/man1 DOC=${D}/usr/share/doc/examiner-0.5 \
		BIN=${D}/usr/bin SHARE=${D}/usr/share/examiner install
	dodoc docs/*

	gzip ${D}/usr/share/doc/examiner-0.5/utils/*
}


