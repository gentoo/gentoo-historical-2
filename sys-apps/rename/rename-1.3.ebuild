# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/rename/rename-1.3.ebuild,v 1.19 2008/02/04 17:12:03 grobian Exp $

inherit toolchain-funcs eutils

DESCRIPTION="tool for easily renaming files"
HOMEPAGE="http://rename.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^CFLAGS/s:-O3:@CFLAGS@:' \
		-e '/strip /s:.*::' \
		Makefile.in
	epatch "${FILESDIR}"/${P}-rename.patch
	epatch "${FILESDIR}"/${P}-build.patch
	tc-export CC
}

src_install() {
	newbin rename renamexm || die
	newman rename.1 renamexm.1
	dodoc README ChangeLog
}

pkg_postinst() {
	ewarn "This has been renamed to 'renamexm' to avoid"
	ewarn "a naming conflict with sys-apps/util-linux."
}
