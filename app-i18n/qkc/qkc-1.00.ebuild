# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/qkc/qkc-1.00.ebuild,v 1.5 2003/09/30 13:36:38 usata Exp $

MY_P="${PN}c${PV/./}"
DESCRIPTION="Quick KANJI code Converter"
SRC_URI="http://hp.vector.co.jp/authors/VA000501/${MY_P}.zip"
HOMEPAGE="http://hp.vector.co.jp/authors/VA000501/"
SLOT="0"
LICENSE="freedist"
KEYWORDS="x86 alpha ppc sparc"
IUSE=""

DEPEND="virtual/glibc
	app-arch/unzip"
S=${WORKDIR}

src_compile() {

	make CC="${CC}" CFLAGS="${CFLAGS}" || die
}

src_install () {
	dobin qkc
	dodoc qkc.doc
	doman qkc.1
}
