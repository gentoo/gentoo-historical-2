# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/lv/lv-4.49.5-r1.ebuild,v 1.5 2003/11/12 03:35:02 matsuu Exp $
MY_P=${PN}${PV//./}
DESCRIPTION="Powerful Multilingual File Viewer"
HOMEPAGE="http://www.ff.iij4u.or.jp/~nrt/lv/"
SRC_URI="http://www.ff.iij4u.or.jp/~nrt/freeware/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc ia64 amd64"
IUSE=""
DEPEND="virtual/glibc
	sys-libs/ncurses"
S=${WORKDIR}/${MY_P}/build
src_compile() {
	../src/configure \
		--prefix=/usr \
		--mandir=/usr/share/man || die
	emake LIBS=-lncurses
}
src_install() {
	dodir /usr/{bin,lib,share/man/man1}
	einstall
}
