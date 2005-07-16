# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pkcrack/pkcrack-1.2.2.ebuild,v 1.3 2005/07/16 11:29:04 dholm Exp $

inherit toolchain-funcs

DESCRIPTION="PkZip cipher breaker"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
SRC_URI="http://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/${P}.tar.gz"
LICENSE="pkcrack"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="test"
DEPEND="test? ( app-arch/zip )
	virtual/libc"
RDEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}/src
	sed -i -e "s/^CC=.*/CC=$(tc-getCC)/" \
		-e "s/^CFLAGS=.*/CFLAGS=${CFLAGS}/" \
		Makefile
	sed -i -e "s:void main:int main:" *.c
}

src_compile() {
	cd ${S}/src
	emake || die "emake failed"
}

src_test() {
	cd ${S}/test
	make CC="$(tc-getCC)" all || die "self test failed"
}

src_install() {
	cd ${S}/src
	dobin pkcrack zipdecrypt findkey extract makekey
	dodoc ${S}/doc/*
}

pkg_postinst() {
	einfo "Author DEMANDS :-) a postcard be sent to:"
	einfo
	einfo "    Peter Conrad"
	einfo "    Am Heckenberg 1"
	einfo "    56727 Mayen"
	einfo "    Germany"
	einfo
	einfo "See: http://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-readme.html"
	epause 5
}
