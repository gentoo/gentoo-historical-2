# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/cvm-vmailmgr/cvm-vmailmgr-0.3.ebuild,v 1.13 2004/06/25 03:11:23 agriffis Exp $

inherit gcc

DESCRIPTION="CVM modules for use with vmailmgr"
HOMEPAGE="http://untroubled.org/cvm-vmailmgr/"
SRC_URI="http://untroubled.org/cvm-vmailmgr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND="virtual/glibc"
RDEPEND=">=net-mail/vmailmgr-0.96.9-r1
	>=sys-apps/ucspi-unix-0.34"

src_compile() {
	echo "$(gcc-getCC) ${CFLAGS}" > conf-cc
	echo "$(gcc-getCC)" > conf-ld
	emake || die
}

src_install() {
	dobin cvm-vmailmgr cvm-vmailmgr-local cvm-vmailmgr-udp || die

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
