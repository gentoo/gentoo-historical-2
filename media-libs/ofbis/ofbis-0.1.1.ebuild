# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/ofbis/ofbis-0.1.1.ebuild,v 1.3 2002/07/11 06:30:39 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Framebuffer graphical library"
SRC_URI="ftp://ftp.nocrew.org/pub/osis/ofbis/"${A}
HOMEPAGE="http://www.nocrew.org/pub/ofbis"

DEPEND="virtual/glibc"

src_compile() {

	try ./configure --prefix=/usr
	try make CFLAGS="${CFLAGS}" all
}

src_install() {

	try make DESTDIR=${D} install
	dodoc AUTHORS CREDITS DESIGN NEW OFBIS-VERSION README TODO ChangeLog doc/ofbis.doc
}
