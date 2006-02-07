# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bubblemon/bubblemon-1.46.ebuild,v 1.6 2006/02/07 08:51:21 agriffis Exp $

DESCRIPTION="A fun monitoring applet for your desktop, complete with swimming duck"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc sparc x86"
IUSE=""
S=${WORKDIR}/${PN}-dockapp-${PV}
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${PN}-dockapp-${PV}.tar.gz"
DEPEND="virtual/libc
	=x11-libs/gtk+-1.2*
	>=sys-apps/sed-4"

src_compile() {
	sed -i "s/CFLAGS = -O3/CFLAGS = ${CFLAGS}/" Makefile
	make || die
}

src_install () {
	into /usr
	dobin bubblemon
	dodoc ChangeLog README doc/* misc/*
}
