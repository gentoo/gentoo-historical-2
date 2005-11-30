# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ondir/ondir-0.2.2.ebuild,v 1.1 2004/10/25 13:57:02 ka0ttic Exp $

DESCRIPTION="program that automatically executes scripts as you traverse directories"
HOMEPAGE="http://swapoff.org/OnDir"
SRC_URI="http://swapoff.org/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/libc
	sys-apps/sed"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "s:\(/man/.*$\):/share\1:g" \
		-e "s:-g:${CFLAGS}:" Makefile || die "sed Makefile failed"
}

src_compile() {
	emake CC="${CC:-gcc}" || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README INSTALL scripts.tcsh scripts.sh
	newdoc ondirrc.eg ondirrc.example
	dohtml changelog.html ondir.1.html
}
