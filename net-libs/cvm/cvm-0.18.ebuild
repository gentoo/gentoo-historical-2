# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/cvm/cvm-0.18.ebuild,v 1.3 2004/06/25 03:10:33 agriffis Exp $

inherit fixheadtails gcc

DESCRIPTION="CVM modules for unix and pwfile, plus testclient"
HOMEPAGE="http://untroubled.org/cvm/"
SRC_URI="http://untroubled.org/cvm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND="virtual/glibc
	>=dev-libs/bglibs-1.009"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	ht_fix_file tests.sh Makefile
}

src_compile() {
	echo "/usr/lib/bglibs/include" > conf-bgincs
	echo "/usr/lib/bglibs/lib" > conf-bglibs
	echo "$(gcc-getCC) ${CFLAGS}" > conf-cc
	echo "$(gcc-getCC) -s" > conf-ld
	make || die
}

src_install() {
	dobin cvm-benchclient cvm-checkpassword cvm-pwfile cvm-testclient cvm-unix || die "dobin failed"

	insinto /usr/include/cvm
	doins *.h
	dosym /usr/include/cvm/sasl.h /usr/include/cvm-sasl.h

	newlib.a client.a libcvm-client.a
	newlib.a udp.a libcvm-udp.a
	newlib.a local.a libcvm-local.a
	newlib.a command.a libcvm-command.a
	newlib.a module.a libcvm-module.a
	newlib.a sasl.a libcvm-sasl.a

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION
	dohtml *.html
}
