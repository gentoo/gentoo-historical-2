# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake/automake-1.5.ebuild,v 1.1 2001/08/27 01:14:11 hallski Exp $

P=automake-1.4-p5
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Used to generate Makefile.in from Makefile.am"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/automake/${A}
	 ftp://prep.ai.mit.edu/gnu/automake/${A}"
HOMEPAGE="http://www.gnu.org/software/automake/automake.html"

DEPEND="sys-devel/perl"

src_compile() {
    try ./configure --prefix=/usr --infodir=/usr/share/info --host=${CHOST}
    try make ${MAKEOPTS}
}

src_install() {
    try make prefix=${D}/usr infodir=${D}/usr/share/info install
    dodoc COPYING NEWS README THANKS TODO AUTHORS ChangeLog
}


