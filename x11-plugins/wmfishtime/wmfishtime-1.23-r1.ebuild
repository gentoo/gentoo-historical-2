# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmfishtime/wmfishtime-1.23-r1.ebuild,v 1.8 2004/06/19 03:57:00 kloeri Exp $

# to make this work in KDE, run it with the -b option :)
DESCRIPTION="A fun clock applet for your desktop featuring swimming fish"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${P}.tar.gz"

SLOT="0"
IUSE=""
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ppc"

DEPEND="=x11-libs/gtk+-1.2*"

src_unpack() {
	unpack ${A} ; cd ${S}
	sed -i -e "s/CFLAGS = -O3/CFLAGS = ${CFLAGS}/" Makefile
}

src_compile() {
	make || die
}

src_install () {
	into /usr
	dobin wmfishtime
	doman wmfishtime.1
	dodoc ALL_I_GET_IS_A_GRAY_BOX CODING INSTALL README AUTHORS COPYING
}
