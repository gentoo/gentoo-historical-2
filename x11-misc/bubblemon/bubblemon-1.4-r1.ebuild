# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bubblemon/bubblemon-1.4-r1.ebuild,v 1.14 2004/06/24 22:14:35 agriffis Exp $

DESCRIPTION="A fun monitoring applet for your desktop, complete with swimming duck"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc"

S=${WORKDIR}/${PN}-dockapp-${PV}
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${PN}-dockapp-${PV}.tar.gz"
DEPEND="virtual/glibc =x11-libs/gtk+-1.2*"

src_compile() {
	sed -i "s/CFLAGS = -O3/CFLAGS = ${CFLAGS}/" Makefile
	make || die
}

src_install () {
	into /usr
	dobin bubblemon
	dodoc INSTALL ChangeLog README doc/* misc/*
}
