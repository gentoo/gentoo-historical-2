# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/avifile/avifile-0.53.5-r1.ebuild,v 1.6 2002/03/19 04:09:02 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Library for AVI-Files"
SRC_URI="http://divx.euro.ru/${P}.tar.gz
	 http://divx.euro.ru/binaries-010122.zip"

HOMEPAGE="http://divx.euro.ru/"

DEPEND="virtual/glibc qt? ( =x11-libs/qt-2* ) >=media-libs/libsdl-1.1.5  app-arch/unzip"
RDEPEND="virtual/glibc qt? ( =x11-libs/qt-2* ) >=media-libs/libsdl-1.1.5"

src_unpack() {
  unpack ${P}.tar.gz
}

src_compile() {
    local myconf
    if [ -z "`use qt`" ] ; then
      myconf="$myconf --disable-qt"
    else
      myconf="$myconf --with-qt-dir=/usr/qt/2"
    fi
    if [ "`use nas`" ] ; then
	LDFLAGS="-L/usr/X11R6/lib -lXt"
    fi
    export CFLAGS=${CFLAGS/-O?/-O2}
    LDFLAGS="$LDFLAGS" ./configure --prefix=/usr --host=${CHOST} --disable-tsc $myconf || die
    cp Makefile Makefile.orig
    sed -e "s:/usr/lib/win32:${D}/usr/lib/win32:" \
	Makefile.orig > Makefile
    make || die
    #cd xmps-avi-plugin
    #cp Makefile Makefile.orig
    #sed -e "s:INCLUDES = :INCLUDES = -I/usr/X11R6/include -I/usr/include/glib/include -I/opt/gnome/include:" \
    # 	Makefile.orig > Makefile
    #try make

}

src_install () {

    dodir /usr/lib /usr/bin
    dodir /usr/lib/win32

    make prefix=${D}/usr install

    cd ${D}/usr/lib/win32
    unzip ${DISTDIR}/binaries-010122.zip
    cd ${S}
    dodoc COPYING README
    cd doc
    dodoc CREDITS EXCEPTIONS FreeBSD LICENSING TODO
    dodoc VIDEO-PERFORMANCE WARNINGS
}





