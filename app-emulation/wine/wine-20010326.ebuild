# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-20010326.ebuild,v 1.4 2001/11/10 02:58:37 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Wine is a free implementation of Windows on Unix."
SRC_URI="ftp://metalab.unc.edu/pub/Linux/ALPHA/wine/development/Wine-${PV}.tar.gz"
HOMEPAGE="http://www.winehq.com"

DEPEND="virtual/glibc
        virtual/x11
         >=sys-libs/ncurses-5.2
         opengl? ( virtual/opengl )"

src_compile() {

    local myconf
    if [ "`use opengl`" ]
    then
        myconf="--enable-opengl"
    else
        myconf="--disable-opengl"
    fi
    try ./configure --prefix=/usr --libdir=/usr/lib/wine --sysconfdir=/etc/wine \
	--host=${CHOST} ${myconf}

    try make depend
    try make

}

src_install () {

    try make prefix=${D}/usr libdir=${D}/usr/lib/wine mandir=${D}/usr/share/man install
    insinto /etc/wine
    doins ${FILESDIR}/wine.conf
    dodoc ANNOUNCE AUTHORS BUGS ChangeLog DEVELOPERS-HINTS LICENSE
    dodoc README WARRANTY

}

