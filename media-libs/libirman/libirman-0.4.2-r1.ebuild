# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libirman/libirman-0.4.2-r1.ebuild,v 1.5 2004/09/24 10:06:36 eradicator Exp $

IUSE=""
inherit eutils

DESCRIPTION="library for Irman control of Unix software"
SRC_URI="http://www.lirc.org/software/snapshots/${P}.tar.gz"
HOMEPAGE="http://www.evation.com/libirman/libirman.html"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 sparc alpha ~ia64 amd64 ~ppc"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-PICShared.patch
	epatch ${FILESDIR}/${P}-destdir.patch
}

src_compile() {
	econf || die

	# See bug #52586 for -j1 reasons
	emake -j1 || die
}

src_install() {
	dodir /usr/include

	make DESTDIR="${D}" \
	     LIRC_DRIVER_DEVICE="${D}/dev/lirc" \
	     install || die

	dobin test_func test_io test_name
	dodoc COPYING* NEWS README* TECHNICAL TODO
}
