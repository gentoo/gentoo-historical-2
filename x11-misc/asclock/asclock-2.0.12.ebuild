# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/asclock/asclock-2.0.12.ebuild,v 1.2 2002/07/08 16:58:05 aliz Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Clock applet for AfterStep"
SRC_URI="http://www.tigr.net/afterstep/download/asclock/${P}.tar.gz"
HOMEPAGE="http://www.tigr.net/afterstep/list.pl"
LICENSE="GPL-2"

DEPEND="virtual/glibc virtual/x11"

src_unpack() {
    unpack ${P}.tar.gz
	cd ${S}
	ln -s themes/classic default_theme
}

src_compile() {
	local x
	for x in asclock parser symbols config
	do
		gcc \
			${CFLAGS} \
			-I/usr/X11R6/include \
			-Dlinux -D__i386__ \
			-D_POSIX_C_SOURCE=199309L \
			-D_POSIX_SOURCE \
			-D_XOPEN_SOURCE \
			-D_BSD_SOURCE \
			-D_SVID_SOURCE \
			-DFUNCPROTO=15 \
			-DNARROWPROTO \
			-c -o ${x}.o ${x}.c || die
	done
	gcc \
		${CFLAGS} \
		-o asclock \
		asclock.o parser.o symbols.o config.o \
		-L/usr/X11R6/lib \
		-L/usr/lib/X11 \
		-lXpm -lXext -lX11 || die  
}

src_install () {
	dobin asclock
	dodir usr/share/asclock
	cp -a themes/* ${D}/usr/share/asclock
	dodoc COPYING INSTALL README README.THEMES TODO
}
