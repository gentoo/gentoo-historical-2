# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/schedtool/schedtool-1.2.3.ebuild,v 1.3 2005/01/02 05:38:48 marineam Exp $

DESCRIPTION="A tool to query or alter a process' scheduling policy."
HOMEPAGE="http://freequaos.host.sk/schedtool"
SRC_URI="http://freequaos.host.sk/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT=0
KEYWORDS="x86 ppc amd64"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i '/^CFLAGS=/d ; s:/man/:/share/man/:' Makefile
}

src_compile() {
	emake || die "Compilation failed."
}

src_install() {
	make DESTPREFIX=${D}/usr install
	dodoc BUGS CHANGES INSTALL LICENSE README THANKS TUNING
}
