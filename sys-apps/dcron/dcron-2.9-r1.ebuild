# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dcron/dcron-2.9-r1.ebuild,v 1.5 2004/06/28 16:03:39 vapier Exp $

inherit eutils

MY_PV=29
S=${WORKDIR}/${PN}
DESCRIPTION="A cute little cron from Matt Dillon"
HOMEPAGE="http://apollo.backplane.com/"
SRC_URI="http://apollo.backplane.com/FreeSrc/${PN}${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~hppa ~amd64"
IUSE=""

DEPEND="virtual/libc
	>=sys-apps/sed-4"
RDEPEND="!virtual/cron
	>=sys-apps/cronbase-0.2.1-r3
	virtual/mta"
PROVIDE="virtual/cron"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/dcron-2.7-Makefile-gentoo.diff

	# fix 'crontab -e' to look at $EDITOR and not $VISUAL
	sed -i 's:VISUAL:EDITOR:g' ${S}/crontab.c

	sed -i 's:VISUAL:EDITOR:g' ${S}/crontab.1

	# remove gcc hardcode
	sed -i "s:\(CC  = \)gcc:\1${CC:-gcc}:" ${S}/Makefile
}

src_compile() {
	make || die
}

src_install() {
	#this does not work if the directory already exists
	diropts -m 0750 -o root -g cron
	keepdir /var/spool/cron/crontabs

	exeopts -m 0700 -o root -g wheel
	exeinto /usr/sbin
	doexe crond

	exeopts -m 4750 -o root -g cron
	exeinto /usr/bin
	doexe crontab

	dodoc CHANGELOG README ${FILESDIR}/crontab
	doman crontab.1 crond.8

	exeinto /etc/init.d ; newexe ${FILESDIR}/dcron.rc6 dcron

	insopts -o root -g root -m 0644
	insinto /etc
	newins ${FILESDIR}/crontab-2.9-r1 crontab
}


pkg_postinst() {
	echo
	einfo "To activate /etc/cron.{hourly|daily|weekly|montly} please run: "
	einfo "crontab /etc/crontab"
	echo
	einfo "!!! That will replace root's current crontab !!!"
	echo
}
