# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/mtink/mtink-0.9.57.ebuild,v 1.1 2003/11/25 17:46:39 lanius Exp $

DESCRIPTION="mtink is a status monitor and inkjet cartridge changer for some Epson printers"
HOMEPAGE="http://xwtools.automatix.de/"
SRC_URI="http://xwtools.automatix.de/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc cups"

DEPEND="virtual/motif
	x11-base/xfree
	cups? ( net-print/cups )"

S="${WORKDIR}/${PN}"

src_compile() {
	cp -f Makefile.ORG Makefile
	make || die "Compile problem"
}

src_install() {
	exeinto /usr/bin
	doexe mtinkc mtink ttink detect/askPrinter

	exeinto /usr/sbin
	doexe mtinkd

	exeinto /etc/init.d
	newexe ${FILESDIR}/mtinkd.rc mtinkd

	insinto /etc/conf.d
	newins ${FILESDIR}/mtinkd.confd mtinkd

	use cups && \
		exeinto /usr/lib/cups/backend; \
		doexe etc/mtink-cups

	dodoc README CHANGE.LOG LICENCE
	use doc && {
		dohtml html/*.gif html/*.html
	}
}

pkg_postinst() {
	einfo
	einfo "mtink needs correct permissions to access printer device."
	einfo "To do this you either need to run the following chmod command:"
	einfo "chmod 666 /dev/<device>"
	einfo "or set the suid bit on mtink, mtinkc and ttink in /usr/bin"
	einfo
}
