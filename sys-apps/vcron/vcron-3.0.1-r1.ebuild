# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/vcron/vcron-3.0.1-r1.ebuild,v 1.1 2002/04/20 22:03:25 bangert Exp $

MY_P=${P/vcron/vixie-cron}
S=${WORKDIR}/${MY_P}
DESCRIPTION="The Vixie cron daemon"
SRC_URI="ftp://ftp.vix.com/pub/vixie/${MY_P}.tar.bz2"

DEPEND="virtual/glibc"

RDEPEND="!virtual/cron
	 sys-apps/cronbase
	 virtual/mta"
PROVIDE="virtual/cron"

src_unpack() {

	unpack ${A}
	
	cd ${S}
	patch -p1 < ${FILESDIR}/${MY_P}-gentoo.patch || die

	cp Makefile Makefile.orig
	sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile
}

src_compile() {

	emake || die
}

src_install() {

	diropts -m0750 -o root -g cron
	dodir /var/spool/cron/crontabs
	
	doman crontab.1 crontab.5 cron.8

	dodoc CHANGES CONVERSION FEATURES MAIL MANIFEST README THANKS

	diropts -m0755 ; dodir /etc/cron.d
	touch ${D}/etc/cron.d/.keep

	exeinto /etc/init.d
	newexe ${FILESDIR}/vcron.rc6 vcron

	insinto /etc
	doins ${FILESDIR}/crontab

	dodoc ${FILESDIR}/crontab

        insinto /usr/sbin
	insopts -o root -g root -m 0750 ; doins cron
	
        insinto /usr/bin
	insopts -o root -g cron -m 4750 ; doins crontab

}
