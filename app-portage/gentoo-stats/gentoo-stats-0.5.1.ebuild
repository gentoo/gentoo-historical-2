# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoo-stats/gentoo-stats-0.5.1.ebuild,v 1.1 2004/03/29 00:12:39 mksoft Exp $

DESCRIPTION="Gentoo Linux usage statistics client daemon"
HOMEPAGE="http://mksoft.co.il/gentoo-stats/"
SRC_URI="http://mksoft.co.il/gentoo-stats/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
# devs: please do not change this, it wouldn't make much sense right now
KEYWORDS="x86 ppc sparc -alpha hppa amd64"

RDEPEND="dev-lang/python"
DEPEND=""

S=${WORKDIR}

src_install() {
	into /usr
	dosbin gentoo-stats
	dodir /etc/gentoo-stats
	insinto /etc/gentoo-stats
	doins gentoo-stats.conf
}

pkg_postinst() {
	ewarn "Please edit /etc/gentoo-stats/gentoo-stats.conf to suit"
	ewarn "your needs."

	echo

	einfo 'To obtain a new system ID, run "gentoo-stats --new".'
	einfo
	einfo "After that, install a new cron job:"
	einfo ""
	einfo "\t0 0 * * 0,4 /usr/sbin/gentoo-stats --update >/dev/null"
	einfo ""
	einfo '(You can edit your cron jobs with "crontab -e" or'
	einfo '"fcrontab -e", depending on the cron daemon you use.)'

	echo

	ewarn "If you're updating from <gentoo-stats-0.2, please remove"
	ewarn "your system ID from the cron job and enter it in"
	ewarn "/etc/gentoo-stats/gentoo-stats.conf instead."
}
