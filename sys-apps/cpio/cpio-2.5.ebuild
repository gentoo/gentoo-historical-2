# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/cpio/cpio-2.5.ebuild,v 1.8 2003/02/24 22:34:58 dragon Exp $

DESCRIPTION="A file archival tool which can also read and write tar files"
SRC_URI="mirror://gnu/cpio/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/cpio/cpio.html"

KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa arm mips"
SLOT="0"
LICENSE="GPL-2 LGPL-2"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv rmt.c rmt.c.orig
	sed -e "78d" rmt.c.orig > rmt.c
}

src_compile() {
	econf
	emake || die
}

src_install() {
	#our official mt is now the mt in app-arch/mt-st (supports Linux 2.4, unlike this one)
	dobin cpio
	doman cpio.1
	doinfo cpio.info
	dodoc COPYING* ChangeLog NEWS README
}
