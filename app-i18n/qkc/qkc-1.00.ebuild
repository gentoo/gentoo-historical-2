# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/qkc/qkc-1.00.ebuild,v 1.3 2003/02/13 08:47:27 vapier Exp $

MY_P=qkcc100
DESCRIPTION="Quick KANJI code Converter"
SRC_URI="http://hp.vector.co.jp/authors/VA000501/${MY_P}.zip"
HOMEPAGE="http://hp.vector.co.jp/authors/VA000501/"
SLOT="0"
LICENSE="freedist"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/glibc
app-arch/unzip"
S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_compile() {

	make CC=gcc CFLAGS="${CFLAGS}" || die
}

src_install () {
	dobin qkc
	dodoc qkc.doc
	doman qkc.1
}
