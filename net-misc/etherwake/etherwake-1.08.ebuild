# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/etherwake/etherwake-1.08.ebuild,v 1.3 2003/07/13 14:31:36 aliz Exp $

DESCRIPTION="This program generates and transmits a Wake-On-LAN (WOL) \"Magic Packet\", used for restarting machines that have been soft-powered-down (ACPI D3-warm state)."
SRC_URI="http://www.scyld.com/pub/diag/ether-wake.c
		http://www.scyld.com/pub/diag/etherwake.8"
HOMEPAGE="http://www.scyld.com/expert/wake-on-lan.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND="virtual/glibc"

src_compile() {
	gcc ${CFLAGS} -o etherwake ${DISTDIR}/ether-wake.c
}

src_install() {                               
	dosbin etherwake
	doman ${DISTDIR}/etherwake.8
	dodoc ${FILESDIR}/readme
}
