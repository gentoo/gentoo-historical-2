# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Aaron Blew <moath@oddbox.org>
# /home/cvsroot/gentoo-x86/x11-terms/aterm/,v 1.2 2001/02/15 18:17:31 achim Exp
# $Header: /var/cvsroot/gentoo-x86/x11-terms/aterm/aterm-0.4.2-r1.ebuild,v 1.2 2002/04/14 13:23:26 seemant Exp $


S=${WORKDIR}/${P}
DESCRIPTION="A terminal emulator with transparency support as well as rxvt backwards compatibility"
SRC_URI="http://prdownloads.sf.net/aterm/${P}.tar.gz"
HOMEPAGE="http://aterm.sourceforge.net"

DEPEND=">=media-libs/jpeg-6b-r2 >=media-libs/libpng-1.0.11 virtual/x11"


src_compile() {
	./configure 	\
		--prefix=/usr	\
		--mandir=/usr/share/man	\
		--host=${CHOST} \
		--enable-transparency \
		--enable-fading \
		--enable-background-image \
		--enable-menubar \
		--enable-graphics \
		--enable-utmp \
		--disable-backspace-key \
		--with-x

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc TODO ChangeLog INSTALL doc/BUGS doc/FAQ doc/README.menu
	docinto menu
	dodoc doc/menu/*
	dohtml -r .
}
