# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbrun/bbrun-1.4.ebuild,v 1.1.1.1 2005/11/30 09:40:22 chriswhite Exp $

DESCRIPTION="blackbox program execution dialog box"
SRC_URI="http://www.darkops.net/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.darkops.net/bbrun/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*"

src_unpack() {
	unpack ${A}
	cd ${S}/bbrun
	mv Makefile Makefile.orig
	sed '/CFLAGS =/ s:$: -I/usr/include/gtk-1.2 -I/usr/include/glib-1.2 '"${CFLAGS}"':' Makefile.orig > Makefile || die
}

src_compile() {
	cd ${S}/bbrun
	emake || die "emake failed"
}

src_install () {
	dobin bbrun/bbrun || die "failed to install bbrun"
	dodoc README COPYING
}
