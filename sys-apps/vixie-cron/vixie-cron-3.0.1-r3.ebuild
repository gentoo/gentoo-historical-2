# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/vixie-cron/vixie-cron-3.0.1-r3.ebuild,v 1.5 2004/01/29 04:42:26 agriffis Exp $

inherit eutils

IUSE="selinux"

SELINUX_PATCH="${P}-selinux.diff.bz2"

S=${WORKDIR}/${P}
DESCRIPTION="The Vixie cron daemon"
HOMEPAGE="http://www.vix.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~amd64 ppc sparc alpha ~arm mips ~hppa ia64"

DEPEND=">=sys-apps/portage-2.0.47-r10
	>=sys-apps/sed-4.0.5
	selinux? ( sys-libs/libselinux )"

RDEPEND="!virtual/cron
	 sys-apps/cronbase
	 virtual/mta
	 selinux? ( sys-libs/libselinux )"

PROVIDE="virtual/cron"

src_unpack() {
	unpack ${A}

	cd ${S}

	epatch ${FILESDIR}/${P}-gentoo.patch
	epatch ${FILESDIR}/${P}-close_stdin.diff

	use selinux && epatch ${FILESDIR}/${SELINUX_PATCH}

	sed -i "s:-O2:${CFLAGS}:" Makefile
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
	newexe ${FILESDIR}/vixie-cron.rc6 vixie-cron

	insinto /etc
	doins ${FILESDIR}/crontab

	dodoc ${FILESDIR}/crontab

	insinto /usr/sbin
	insopts -o root -g root -m 0750 ; doins cron

	insinto /usr/bin
	insopts -o root -g cron -m 4750 ; doins crontab
}

pkg_postinst() {

	if [ -f ${ROOT}/etc/init.d/vcron ]
	then
		ewarn "Please run:"
		ewarn "rc-update del vcron"
		ewarn "rc-update add vixie-cron default"
	fi
}
