# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmfishtime/wmfishtime-1.24.ebuild,v 1.5 2005/09/03 21:12:42 corsair Exp $

# to make this work in KDE, run it with the -b option :)
IUSE=""
DESCRIPTION="A fun clock applet for your desktop featuring swimming fish"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc ppc64 sparc x86"

DEPEND="=x11-libs/gtk+-1.2*
	>=sys-apps/sed-4"

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
