# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Thread <thread@threadbox.net>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/qiv/qiv-1.7.ebuild,v 1.1 2001/07/22 06:24:33 jerry Exp $

A=${P}-src.tgz
S=${WORKDIR}/${P}
DESCRIPTION="Quick Image Viewer"
SRC_URI="http://www.klografx.net/qiv/download/${A}"
HOMEPAGE="http://www.klografx.net/qiv"

DEPEND="virtual/glibc sys-devel/gcc
    >=media-libs/tiff-3.5.5
    >=media-libs/libpng-1.0.7
    >=media-libs/imlib-1.9.10
    virtual/x11"

src_compile(){
    try make
}

src_install () {
    dobin qiv
    doman qiv.1
    dodoc README*
}
