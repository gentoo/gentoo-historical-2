# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/nas/nas-1.4.1-r1.ebuild,v 1.2 2001/02/15 18:17:31 achim Exp $

A=${P}.src.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The Network Audio System"
SRC_URI="http://radscan.com/nas/${A}"
HOMEPAGE="http://radscan.com/nas.html"

DEPEND="virtual/glibc
	>=x11-base/xfree-4.0.1"

src_compile() {

    cd ${S}
    try xmkmf
    try make WORLDOPTS=\'-k YACC=\"bison -y\" CDEBUGFLAGS=\"$(CDEBUGFLAGS) -DSTARTSERVER\"\' World

}

src_install () {

    cd ${S}
    try make DESTDIR=${D} install
    dodoc BUGS BUILDNOTES FAQ HISTORY README RELEASE TODO doc/*.ps
}

