# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ryan Tolboom <ryan@intphsys.com>
# $Header: /var/cvsroot/gentoo-x86/app-text/xpdf/xpdf-0.92-r1.ebuild,v 1.1 2001/02/14 03:07:44 ryan Exp $

S=${WORKDIR}/${P}

SRC_URI="ftp://ftp.foolabs.com/pub/xpdf/${P}.tgz"

HOMEPAGE="http://www.foolabs.com/xpdf/xpdf.html"

DESCRIPTION="An X Viewer for PDF Files"

DEPEND=">=x11-base/xfree-4.0.1"

src_compile() {

    try ./configure --prefix=/usr/X11R6 --with-gzip
    try make

}


src_install() {

    try make DESTDIR=${D} install
    dodoc README ANNOUNCE CHANGES

}
