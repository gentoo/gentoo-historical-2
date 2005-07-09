# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/nullmailer/nullmailer-1.00_rc7-r4.ebuild,v 1.7 2005/07/09 03:01:55 swegener Exp $

inherit eutils

MY_P="${P/_rc/RC}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simple relay-only local mail transport agent"
SRC_URI="http://untroubled.org/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://untroubled.org/${PN}/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE="mailwrapper"

DEPEND="virtual/libc
		sys-apps/groff"
RDEPEND="!mailwrapper? ( !virtual/mta )
		mailwrapper? ( >=net-mail/mailwrapper-0.2 )
		virtual/libc
		>=sys-process/supervise-scripts-3.2
		>=sys-process/daemontools-0.76-r1
		sys-apps/shadow"
PROVIDE="virtual/mta"

NULLMAILER_GROUP_NAME=nullmail
NULLMAILER_GROUP_GID=88
NULLMAILER_USER_NAME=nullmail
NULLMAILER_USER_UID=88
NULLMAILER_USER_SHELL=/bin/false
NULLMAILER_USER_GROUPS=nullmail
NULLMAILER_USER_HOME=/var/nullmailer

setupuser() {
	enewgroup ${NULLMAILER_GROUP_NAME} ${NULLMAILER_GROUP_GID}
	enewuser ${NULLMAILER_USER_NAME} ${NULLMAILER_USER_UID} ${NULLMAILER_USER_SHELL} ${NULLMAILER_USER_HOME} ${NULLMAILER_USER_GROUPS}
}

pkg_setup() {
	setupuser
}

src_compile() {
	# Note that we pass a different directory below due to bugs in the makefile!
	econf --localstatedir=/var || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	einstall localstatedir=${D}/var/nullmailer || die "einstall failed"
	if use mailwrapper; then
		mv ${D}/usr/sbin/sendmail ${D}/usr/sbin/sendmail.nullmailer
		mv ${D}/usr/bin/mailq ${D}/usr/bin/mailq.nullmailer
		dosym /usr/sbin/sendmail /usr/bin/mailq
		insinto /etc/mail
		doins ${FILESDIR}/mailer.conf
	fi
	dodoc AUTHORS BUGS COPYING HOWTO INSTALL NEWS README YEAR2000 TODO ChangeLog
	# A small bit of sample config
	dodir /etc/nullmailer
	insinto /etc/nullmailer
	newins ${FILESDIR}/remotes.sample remotes
	# daemontools stuff
	dodir /var/nullmailer/service{,/log}
	insinto /var/nullmailer/service
	newins scripts/nullmailer.run run
	fperms 700 /var/nullmailer/service/run
	insinto /var/nullmailer/service/log
	newins scripts/nullmailer-log.run run
	fperms 700 /var/nullmailer/service/log/run
	# usablity
	dodir /usr/lib
	dosym /usr/sbin/sendmail usr/lib/sendmail
	# permissions stuff
	keepdir /var/log/nullmailer /var/nullmailer/{tmp,queue}
	fperms 770 /var/log/nullmailer /var/nullmailer/{tmp,queue}
	fowners nullmail:nullmail /usr/sbin/nullmailer-queue /usr/bin/mailq
	fperms 4711 /usr/sbin/nullmailer-queue /usr/bin/mailq
	fowners nullmail:nullmail /var/log/nullmailer /var/nullmailer/{tmp,queue,trigger}
	fperms 660 /var/nullmailer/trigger
	use mailwrapper && \
		ewarn "Please ensure you have selected nullmailer in your /etc/mailer.conf"
}

pkg_config() {
	[ ! -s /etc/nullmailer/me ] && /bin/hostname --fqdn >/etc/nullmailer/me
	[ ! -s /etc/nullmailer/defaultdomain ] && /bin/hostname --domain >/etc/nullmailer/defaultdomain
	use mailwrapper && \
		ewarn "Please ensure you have selected nullmailer in your /etc/mailer.conf"
}

pkg_postinst() {
	setupuser
	# Do this again for good measure
	[ ! -e /var/nullmailer/trigger ] && mkfifo /var/nullmailer/trigger
	chown nullmail:nullmail /var/log/nullmailer /var/nullmailer/{tmp,queue,trigger}
	chmod 770 /var/log/nullmailer /var/nullmailer/{tmp,queue}
	chmod 660 /var/nullmailer/trigger

	einfo "To create an initial setup, please do:"
	einfo "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo "To start nullmailer at boot you have to enable the /etc/init.d/svscan rc file"
	einfo "and create the following links :"
	einfo "ln -fs /var/nullmailer/service /service/nullmailer"
	use mailwrapper && \
		ewarn "Please ensure you have selected nullmailer in your /etc/mailer.conf"
}
