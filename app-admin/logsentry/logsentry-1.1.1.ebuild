# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/logsentry/logsentry-1.1.1.ebuild,v 1.15 2004/06/24 21:30:51 agriffis Exp $

DESCRIPTION="automatically monitor system logs and mail security violations on a periodic basis"

# Seems that the project has been discontinued by CISCO?
#HOMEPAGE="http://www.psionic.com/products/logsentry.html/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"
IUSE=""
DEPEND=">=sys-apps/sed-4"
RDEPEND="mail-client/mailx"

S=${WORKDIR}/logcheck-${PV}

src_compile() {
	einfo "compile and install mixed in the package makefile"
}

src_install() {
	dodir /usr/bin /etc/logcheck/tmp /etc/cron.hourly
	cp systems/linux/logcheck.sh{,.orig}
	sed -i \
		-e 's:/usr/local/bin:/usr/bin:' \
		-e 's:/usr/local/etc:/etc/logcheck:' \
		systems/linux/logcheck.sh || \
			die "sed logcheck.sh failed"
	sed -i \
		-e "s:/usr/local/bin:${D}/usr/bin:" \
		-e "s:/usr/local/etc:${D}/etc/logcheck:" \
		Makefile || die "sed Makefile failed"
	make CFLAGS="${CFLAGS}" linux || die

	dodoc README* CHANGES CREDITS
	dodoc systems/linux/README.*

	cat << EOF > ${D}/etc/cron.hourly/logsentry.cron
#!/bin/sh
#
# Uncomment the following if you want
# logsentry (logcheck) to run hourly
#
# this is part of the logsentry package
#
#

#/bin/sh /etc/logcheck/logcheck.sh
EOF
}

pkg_postinst() {
	einfo
	einfo "Uncomment the logwatch line in /etc/cron.hourly/logsentry.cron,"
	einfo "or add directly to root's crontab"
	einfo
}
