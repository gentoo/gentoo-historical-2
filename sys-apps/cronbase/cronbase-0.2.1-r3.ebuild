# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/cronbase/cronbase-0.2.1-r3.ebuild,v 1.9 2004/04/07 20:49:50 kloeri Exp $

DESCRIPTION="The is the base for all cron ebuilds."
HOMEPAGE="http://www.gentoo.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc sparc alpha ~mips hppa ~ia64 ppc64 s390"

src_install() {
	exeinto /usr/sbin
	doexe ${FILESDIR}/run-crons

	diropts -m0750; keepdir /etc/cron.hourly
	diropts -m0750; keepdir /etc/cron.daily
	diropts -m0750; keepdir /etc/cron.weekly
	diropts -m0750; keepdir /etc/cron.monthly

	diropts -m0750 -o root -g cron; keepdir /var/spool/cron

	diropts -m0750; keepdir /var/spool/cron/lastrun

	dodoc ${FILESDIR}/README
}
