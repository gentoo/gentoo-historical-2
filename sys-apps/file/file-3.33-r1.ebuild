# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/file/file-3.33-r1.ebuild,v 1.1 2001/02/07 15:51:27 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Program to identify a file's format by scanning binary data for patters"
#unfortunately, this ftp site doesn't support passive ftp
#maybe we can find an alternative for those behind firewalls, or mirror
#on cvs.gentoo.org
SRC_URI="ftp://ftp.astron.com/pub/file/${A}"

DEPEND="virtual/glibc"

src_compile() {

    try ./configure --prefix=/usr --datadir=/usr/share/misc --host=${CHOST}
    try pmake
}

src_install() {

	dobin file
	doman file.1 magic.4
	insinto /usr/share/misc
	doins magic magic.mime
	dodoc LEGAL.NOTICE MAINT README
}



