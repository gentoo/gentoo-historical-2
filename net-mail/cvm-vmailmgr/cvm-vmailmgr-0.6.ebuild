# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/cvm-vmailmgr/cvm-vmailmgr-0.6.ebuild,v 1.4 2004/07/01 22:30:18 eradicator Exp $

inherit fixheadtails gcc

DESCRIPTION="CVM modules for use with vmailmgr"
HOMEPAGE="http://untroubled.org/cvm-vmailmgr/"
SRC_URI="http://untroubled.org/cvm-vmailmgr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND="virtual/libc
	net-libs/cvm
	>=dev-libs/bglibs-1.009"

RDEPEND=">=net-mail/vmailmgr-0.96.9-r1
	>=sys-apps/ucspi-unix-0.34
	net-libs/cvm
	virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	ht_fix_file Makefile
	sed 's|-lcvm/|-lcvm-|g' -i Makefile
}


src_compile() {
	echo "/usr/lib/bglibs/include" > conf-bgincs
	echo "/usr/lib/bglibs/lib" > conf-bglibs
	echo "$(gcc-getCC) ${CFLAGS}" > conf-cc
	echo "$(gcc-getCC) -s" > conf-ld
	make || die
}

src_install() {
	dobin cvm-vmailmgr cvm-vmailmgr-local cvm-vmailmgr-udp cvm-vmlookup || die

	exeinto /var/lib/supervise/cvm-vmailmgr
	newexe ${FILESDIR}/run-cvm-vmailmgr run

	exeinto /var/lib/supervise/cvm-vmailmgr/log
	newexe ${FILESDIR}/run-cvm-vmailmgr-log run

	insinto /etc/vmailmgr
	doins ${FILESDIR}/cvm-vmailmgr-socket

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION
}

pkg_postinst() {
	einfo "To start cvm-vmailmgr you need to link"
	einfo "/var/lib/supervise/cvm-vmailmgr to /service"
}
