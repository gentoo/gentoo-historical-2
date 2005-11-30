# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/sparc32/sparc32-1.1.ebuild,v 1.1.1.1 2005/11/30 09:53:51 chriswhite Exp $

DESCRIPTION="A SPARC32 compilation environment."
LICENSE="GPL-2"
SRC_URI="ftp://ftp.auxio.org/pub/linux/SOURCES/${P}.tgz"
SLOT="0"

KEYWORDS="-* sparc"
IUSE=""

src_unpack() {
	unpack ${A}
	patch -p0 -i ${FILESDIR}/sparc32-1.1-include.patch
	patch -p0 -i ${FILESDIR}/sparc32-1.1-fhs.patch
}

src_compile() {
	emake || die
}

src_install () {
	make prefix=${D} install
}
