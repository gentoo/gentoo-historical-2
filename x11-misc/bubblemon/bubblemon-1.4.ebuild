# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bubblemon/bubblemon-1.4.ebuild,v 1.5 2001/09/22 06:45:39 woodchip Exp $

DESCRIPTION="A fun monitoring applet for your desktop, complete with swimming duck"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"

S=${WORKDIR}/${PN}-dockapp-${PV}
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${PN}-dockapp-${PV}.tar.gz"
DEPEND="virtual/glibc >=x11-libs/gtk+-1.2.8"

src_compile() {

	sed -e "s/CFLAGS = -O3/CFLAGS = ${CFLAGS}/" Makefile | cat > Makefile
	make ; assert
}

src_install () {

	into /usr
	dobin bubblemon
	dodoc INSTALL ChangeLog README doc/* misc/*
}
