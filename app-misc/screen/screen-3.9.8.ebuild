# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Ben Lutgens
# $Header: /home/cvsroot/gentoo-x86/app-misc/screen.ebuild,v 1.2 2001/04/21
# 19:25 CST blutgens Exp $

#P=
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION=" Screen is a full-screen window manager that multiplexes a
physical terminal between several processes"
SRC_URI="ftp://ftp.uni-erlangen.de/pub/utilities/screen/${A}"
HOMEPAGE="http://www.gnu.org/software/screen/"

DEPEND="virtual/glibc
        >=sys-libs/ncurses-5.2"

src_compile() {

    try ./configure --prefix=/usr --host=${CHOST} --with-sys-screenrc=/etc/screen/screenrc \
	--mandir=/usr/share --libexecdir=/usr/lib/misc\
	--host=${CHOST}
    try make CFLAGS=\"$CFLAGS\"

}

src_install () {

    dodir /usr/bin
    insinto /usr/bin
    dobin screen
    dodir
    insinto /usr/share/terminfo
    doins terminfo/screencap
    insinto /etc/screen
    doins etc/screenrc
    dodoc README ChangeLog INSTALL COPYING TODO
    docinto doc
    cd doc
    dodoc FAQ README.DOTSCREEN 
    docinto print
    dodoc fdpat.ps window_to_display.ps
    doinfo *.info*
    doman screen.1
}

