# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/smpeg-xmms/smpeg-xmms-0.2.5.ebuild,v 1.2 2000/08/16 04:38:11 drobbins Exp $

P=smpeg-xmms-0.2.5
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A MPEG Plugin for XMMS"
SRC_URI="ftp://ftp.xmms.org/xmms/plugins/smpeg-xmms/${A}"
HOMEPAGE="http://www.xmms.org/plugins_input.html"


src_compile() {

    cd ${S}
    ./configure --prefix=/usr/X11R6 --host=${CHOST}
    make

}

src_install () {

    cd ${S}
    make DESTDIR=${D} install
    dodoc AUTHORS COPYING README TODO ChangeLog
}



