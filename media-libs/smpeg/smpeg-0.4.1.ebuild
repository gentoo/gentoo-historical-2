# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/smpeg/smpeg-0.4.1.ebuild,v 1.3 2000/11/02 02:17:12 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="SDL MPEG Player Library"
SRC_URI="ftp://ftp.lokigames.com/pub/open-source/smpeg/${A}"
HOMEPAGE="http://www.lokigames.com/development/smpeg.php3"

DEPEND=">=sys-apps/bash-2.04
	>=sys-libs/glibc-2.1.3
	>=media-libs/libsdl-1.1.5
	>=media-libs/mesa-glu-3.2.1
	>=dev-libs/glib-1.2.8
	>=x11-libs/gtk+-1.2.8"

src_compile() {

    cd ${S}
    try ./configure --prefix=/usr --host=${CHOST} 
#--disable-opengl-player
    try make

}

src_install () {

    cd ${S}
    try make DESTDIR=${D} install
   prepman
   dodoc CHANGES COPYING README* TODO
}




