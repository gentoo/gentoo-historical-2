# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glimpse/glimpse-4.15-r1.ebuild,v 1.1 2003/02/27 06:35:04 vapier Exp $

inherit eutils

DESCRIPTION="A index/query system to search a large set of files quickly"
SRC_URI="http://webglimpse.net/trial/${P}.tar.gz"
HOMEPAGE="http://webglimpse.net/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ~ppc ~mips"

src_compile() {
	epatch ${FILESDIR}/${PV}-errno.patch
	make distclean || die
	econf || die
	make || die
}

src_install() {
	einstall || die
	dodir /usr/share/man/man1
	mv ${D}/usr/share/man/*.1 ${D}/usr/share/man/man1/
}
