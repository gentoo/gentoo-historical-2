# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/smpeg-xmms/smpeg-xmms-0.3.1.ebuild,v 1.3 2000/11/05 12:59:09 achim Exp $

P=smpeg-xmms-0.3.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A MPEG Plugin for XMMS"
SRC_URI="ftp://ftp.xmms.org/xmms/plugins/smpeg-xmms/${A}"
HOMEPAGE="http://www.xmms.org/plugins_input.html"

DEPEND=">=media-sound/xmms-1.2.3"
RDEPEND=">=media-sound/xmms-1.2.3"

src_compile() {

    cd ${S}
    local myopts
    if [ -n "`use gnome`" ]
    then
	myopts="--prefix=/opt/gnome"
    else
	myopts="--prefix=/usr/X11R6"
    fi
    try ./configure ${myopts} --host=${CHOST}
    try make

}

src_install () {

    cd ${S}
    try make DESTDIR=${D} install
    dodoc AUTHORS COPYING README TODO ChangeLog
}



