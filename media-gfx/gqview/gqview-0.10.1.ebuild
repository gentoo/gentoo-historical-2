# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gqview/gqview-0.10.1.ebuild,v 1.1 2001/03/22 18:31:59 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A GNOME image browser"
SRC_URI="http://download.sourceforge.net/gqview/${A}"
HOMEPAGE="http://gqview.sourceforge.net"

DEPEND="virtual/glibc
	gnome-base/gdk-pixbuf
	nls? ( sys-devel/gettext )"

src_compile() {
    local myconf
    if [ -z "`use nls`" ]
    then
      myconf="--disable-nls"
    fi

    try ./configure --prefix=/opt/gnome --host=${CHOST} ${myconf}
    try make

}

src_install () {

    try make prefix=${D}/opt/gnome mandir=${D}/opt/gnome/share/man install

}

