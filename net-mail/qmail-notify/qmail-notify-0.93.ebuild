# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/qmail-notify/qmail-notify-0.93.ebuild,v 1.11 2004/06/24 23:27:44 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Delayed delivery notification for qmail."
SRC_URI="http://untroubled.org/qmail-notify/${P}.tar.gz"
HOMEPAGE="http://untroubled.org/qmail-notify/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"

DEPEND="virtual/glibc"

RDEPEND="virtual/cron
	mail-mta/qmail"

src_compile() {
	cd ${S}
	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
	emake || die
}

src_install () {
	exeinto /usr/sbin
	doexe qmail-notify

	exeinto /etc/cron.hourly
	doexe ${FILESDIR}/qmail-notify.cron

	dodoc README ANNOUNCEMENT TODO cron.hourly
}

pkg_postinst() {
	echo
	einfo "Edit qmail-notify.cron in /etc/cron.hourly"
	einfo "to activate qmail-notify!"
	echo
}
