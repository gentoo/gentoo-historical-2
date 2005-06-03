# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/ext2resize/ext2resize-1.1.17-r2.ebuild,v 1.4 2005/06/03 19:27:21 plasmaroo Exp $

inherit flag-o-matic eutils

DESCRIPTION="EXT2 and EXT3 filesystem resizing utilities"
HOMEPAGE="http://ext2resize.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha arm amd64"
IUSE="static"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}

	# stupid packaged source isn't clean
	make distclean || die "distclean failed"
	sed -i 's:CFLAGS =:CFLAGS +=:' src/Makefile.in

	# Fix broken source for non-''old'' GCCs
	sed -e 's/printf(__FUNCTION__ \"\\n\");/printf(\"%s\\n\", __FUNCTION__);/g' -i src/*.c
	epatch ${FILESDIR}/${P}-gcc3.3.patch
	epatch ${FILESDIR}/${P}-linux26.patch
}

src_compile() {
	use static && append-ldflags -static
	econf --exec-prefix="/" || die "Configure failed"
	emake LDFLAGS="${LDFLAGS}" || die "Make failed"
}

src_install() {
	make install DESTDIR=${D} || die "Install failed"
	dodir /usr/sbin
	dosym ../../sbin/ext2online /usr/sbin/ext2online
	dosym ../../sbin/ext2prepare /usr/sbin/ext2prepare
	dosym ../../sbin/ext2resize /usr/sbin/ext2resize
}
