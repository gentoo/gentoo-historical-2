# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/vcron/vcron-3.0.1-r1.ebuild,v 1.16 2003/02/21 02:34:19 zwelch Exp $

MY_P=${P/vcron/vixie-cron}
S=${WORKDIR}/${MY_P}
DESCRIPTION="The Vixie cron daemon"
SRC_URI="ftp://ftp.vix.com/pub/vixie/${MY_P}.tar.bz2"
HOMEPAGE="http://www.vix.com/"
KEYWORDS="x86 ppc sparc alpha arm"
SLOT="0"
LICENSE="as-is"

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
	#this does not work if the directory exists already
	diropts -m0750 -o root -g cron
	dodir /var/spool/cron/crontabs
	keepdir /var/spool/cron/crontabs/

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
