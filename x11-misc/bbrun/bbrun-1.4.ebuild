# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbrun/bbrun-1.4.ebuild,v 1.7 2004/08/14 14:56:26 swegener Exp $

IUSE=""
DESCRIPTION="blackbox program execution dialog box"
SRC_URI="http://www.dwave.net/~jking/bbrun/${P}.tar.gz"
HOMEPAGE="http://www.dwave.net/~jking/bbrun/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"

DEPEND="virtual/blackbox
	=x11-libs/gtk+-1.2*"

src_unpack() {
	unpack ${A}
	cd ${S}/bbrun
	mv Makefile Makefile.orig
	sed '/CFLAGS =/ s:$: -I/usr/include/gtk-1.2 -I/usr/include/glib-1.2 '"${CFLAGS}"':' Makefile.orig > Makefile || die
}

src_compile() {

	cd ${S}/bbrun
	emake || die

}

src_install () {

	dobin bbrun/bbrun
	dodoc README COPYING

}
