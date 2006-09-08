# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/bsdsfv/bsdsfv-1.18-r1.ebuild,v 1.8 2006/09/08 00:02:41 dang Exp $

inherit eutils toolchain-funcs

DESCRIPTION="all-in-one SFV checksum utility"
HOMEPAGE="http://bsdsfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/bsdsfv/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa m68k ppc ppc-macos s390 sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-64bit.patch
}

src_compile() {
	emake STRIP=true CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dobin bsdsfv || die
	dodoc README MANUAL
}
