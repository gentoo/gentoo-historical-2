# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Mikael Hallendal <micke@hallendal.net>
# $Header: /var/cvsroot/gentoo-x86/gnome-apps/gtktalog/gtktalog-0.99.1.ebuild,v 1.1 2001/06/14 21:58:55 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The GTK disk catalog."
SRC_URI="ftp://gtktalog.sourceforge.net/pub/gtktalog/gtktalog/tgz/${A}"
HOMEPAGE="http://gtktalog.sourceforge.net"

DEPEND=">=x11-libs/gtk+-1.2.0
	>=gnome-base/gnome-libs-1.0.0
	>=sys-libs/zlib-1.1.3
	nls? ( sys-devel/gettext )"

src_compile() {

    local myconf
    if [ -z "`use nls`" ] ; then
        myconf="--disable-nls"
    fi
    try ./configure --prefix=/opt/gnome --sysconfdir=/etc/opt/gnome \
	            --mandir=/opt/gnome/man --host=${CHOST} \
	            --enable-htmltitle --enable-mp3info --enable-aviinfo \
	            --enable-mpeginfo --enable-modinfo --enable-catalog2
                    --enable-catalog3 $myconf

    try pmake

}

src_install () {

    try make DESTDIR=${D} install
    dodoc AUTHORS BUGS COPYING ChangeLog NEWS README TODO

}
