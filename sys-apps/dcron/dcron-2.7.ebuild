# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dcron/dcron-2.7.ebuild,v 1.1 2000/12/22 20:59:36 drobbins Exp $

A=dcron27.tgz
S=${WORKDIR}/dcron
DESCRIPTION="A cute little cron from Matt Dillon"
SRC_URI="http://apollo.backplane.com/FreeSrc/${A}"

HOMEPAGE="http://apollo.backplane.com"

DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {                           
	try make
}

src_install() {
	dobin crontab
	dosbin crond
	chown root.wheel /usr/sbin/crond
	chown root.cron /usr/bin/crontab
	chmod 700 ${D}/usr/sbin/crond
	chmod 4750 ${D}/usr/bin/crontab
	doman *.[18]
	diropts -m0750
	dodir /var/spool/cron/crontabs
	dodoc CHANGELOG README
}

