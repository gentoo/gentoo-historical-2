# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt/rxvt-2.7.8.ebuild,v 1.1 2001/12/07 05:13:14 jerrya Exp $

S=${WORKDIR}/${P}
DESCRIPTION="rxvt -- nice small x11 terminal"
SRC_URI="ftp://ftp.rxvt.org/pub/rxvt/${P}.tar.gz"

HOMEPAGE=http://www.rxvt.org

DEPEND="virtual/glibc
	virtual/x11"


src_compile() {
	./configure --host=${CHOST} --prefix=/usr \
		--enable-rxvt-scroll \
		--enable-transparency \
		--enable-xpm-background \
		--enable-utmp \
		--enable-wtmp \
		--enable-mousewheel \
		--enable-slipwheeling \
		--enable-smart-resize \
		--enable-menubar \
		--enable-shared \
		--enable-keepscrolling

	emake || die
}

src_install() {
	make prefix=${D}/usr install || die

	cd ${S}/doc
	dodoc README* *.html *.txt BUGS FAQ
}
