# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ben Lutgens <ben@sistina.com>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/xfce/xfce-3.8.7-r1.ebuild,v 1.2 2001/10/12 01:17:07 hallski Exp $
 
S=${WORKDIR}/${P}
DESCRIPTION="XFce is a lightweight desktop environment for various UNIX systems."
SRC_URI="http://prdownloads.sourceforge.net/xfce/${P}.tar.gz"
HOMEPAGE="http://www.xfce.org/"

DEPEND="virtual/x11
        >=x11-libs/gtk+-1.2.10-r4
	gnome? ( >=media-libs/gdk-pixbuf-0.11.0-r1 )"

if [ -z "`use gnome`" ]
then
    DEPEND="${DEPEND} >=media-libs/imlib-1.9.10-r1"
fi

src_compile() {
    local myconf

    if [ "`use gnome`" ]
    then
	myconf="--enable-imlib=no --enable-gdk-pixbuf=/usr"
    fi

    ./configure --host=${CHOST}						\
		--prefix=/usr						\
	 	--mandir=/usr/share/man					\
		--with-data-dir=/usr/share/xfce				\
		--with-conf-dir=/etc/X11/xfce 				\
		--with-locale-dir=/usr/share/locale ${myconf}
    try make
}

src_install () {
    try make DESTDIR=${D} install
    dodoc ChangeLog* AUTHORS LICENSE README* TODO*
    dodir /etc/skel/.xfce
}
