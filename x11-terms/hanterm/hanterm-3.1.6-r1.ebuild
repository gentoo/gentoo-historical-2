# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Jays Kwak <jayskwak@gentoo.or.kr>
# $Header: /var/cvsroot/gentoo-x86/x11-terms/hanterm/hanterm-3.1.6-r1.ebuild,v 1.1 2002/07/11 03:55:14 jayskwak Exp $ 

S=${WORKDIR}/${P}
DESCRIPTION="Hanterm -- Korean terminal"
#SRC_URI="http://www.kr.freebsd.org/~hwang/hanterm/${P}.tar.gz"
SRC_URI="http://hanterm.org/download/${P}.tar.gz"
SLOT="0"
KEYWORDS="x86"

HOMEPAGE="http://www.hanterm.org"

DEPEND="virtual/glibc
	>=x11-libs/Xaw3d-1.5
	virtual/x11
	x11-misc/baekmuk-fonts"

src_compile() {
	./configure 	\
		--host=${CHOST}	\
		--prefix=/usr \
		--mandir=/usr/share/man	\
		--with-Xaw3d \
		--with-utempter

	emake || die
}

src_install() {
	make 	\
		prefix=${D}/usr	\
		mandir=${D}/usr/share/man	\
		install || die
	install -d ${D}/usr/X11R6/lib/X11/app-defaults/
	install -m 644 Hanterm.ad ${D}/usr/X11R6/lib/X11/app-defaults/Hanterm.orig
	install -m ${FILESDIR}/Hanterm.gentoo ${D}/usr/X11R6/lib/X11/app-defaults/Hanterm

	cd ${S}/doc
	dodoc TODO COPYING THANKS
}
