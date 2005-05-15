# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/qkc/qkc-1.00.ebuild,v 1.12 2005/05/15 18:31:35 usata Exp $

inherit toolchain-funcs

MY_P="${PN}c${PV/./}"
DESCRIPTION="Quick KANJI code Converter"
HOMEPAGE="http://hp.vector.co.jp/authors/VA000501/"
SRC_URI="http://hp.vector.co.jp/authors/VA000501/${MY_P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86 alpha ppc sparc amd64 ppc64"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}

src_compile() {
	make CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin qkc || die
	dodoc qkc.doc
	doman qkc.1
}
