# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/nullmailer/nullmailer-1.04.ebuild,v 1.4 2008/06/26 16:43:36 nixnut Exp $

inherit eutils flag-o-matic

MY_P="${P/_rc/RC}"
S=${WORKDIR}/${MY_P}
DEBIAN_PV="1"
DEBIAN_SRC="${MY_P/-/_}-${DEBIAN_PV}.diff.gz"
DESCRIPTION="Simple relay-only local mail transport agent"
SRC_URI="http://untroubled.org/${PN}/${MY_P}.tar.gz
		mirror://debian/pool/main/n/${PN}/${DEBIAN_SRC}"
HOMEPAGE="http://untroubled.org/nullmailer/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"

IUSE=""

DEPEND="virtual/libc
		sys-apps/groff"
RDEPEND="virtual/libc
	sys-apps/shadow
	virtual/logger
	!virtual/mta"
PROVIDE="virtual/mta"

src_unpack() {
	unpack ${MY_P}.tar.gz
	EPATCH_OPTS="-d ${S} -p1" \
	epatch "${DISTDIR}"/${DEBIAN_SRC}
	EPATCH_OPTS="-d ${S} -p1" \
	epatch "${S}"/debian/patches/02_ipv6.diff || die "IPV6 patch failed"
	EPATCH_OPTS="-d ${S} -p1" \
	epatch "${S}"/debian/patches/03_syslog.diff || die "daemon/syslog patch failed"
	# this fixes the debian daemon/syslog to actually compile
	sed -i.orig \
		-e '/^nullmailer_send_LDADD/s, =, = ../lib/cli++/libcli++.a,' \
		"${S}"/src/Makefile.am || die "Sed failed"
}

pkg_setup() {
	enewgroup nullmail 88
	enewuser nullmail 88 -1 /var/nullmailer nullmail
}

src_compile() {
	# Note that we pass a different directory below due to bugs in the makefile!
	econf --localstatedir=/var || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	einstall localstatedir="${D}"/var/nullmailer || die "einstall failed"
	dodoc AUTHORS BUGS HOWTO INSTALL ChangeLog NEWS README YEAR2000 TODO
	# A small bit of sample config
	insinto /etc/nullmailer
	newins "${FILESDIR}"/remotes.sample-1.04 remotes
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
	newinitd "${FILESDIR}"/init.d-nullmailer nullmailer
}

pkg_postinst() {
	[ ! -e "${ROOT}"/var/nullmailer/trigger ] && mkfifo "${ROOT}"/var/nullmailer/trigger
	chown nullmail:nullmail "${ROOT}"/var/log/nullmailer "${ROOT}"/var/nullmailer/{tmp,queue,trigger}
	chmod 770 "${ROOT}"/var/log/nullmailer "${ROOT}"/var/nullmailer/{tmp,queue}
	chmod 660 "${ROOT}"/var/nullmailer/trigger

	elog "To create an initial setup, please do:"
	elog "emerge --config =${CATEGORY}/${PF}"
	echo
	elog "To start nullmailer at boot you may use either the nullmailer init.d"
	elog "script, or emerge sys-process/supervise-scripts, enable the"
	elog "svscan init.d script and create the following link:"
	elog "ln -fs /var/nullmailer/service /service/nullmailer"
	echo
	ewarn "${PF} introduces a new configuration syntax for SMTP AUTH."
	ewarn "Please adjust your configuration accordingly."
}

pkg_config() {
	if [ ! -s "${ROOT}"/etc/nullmailer/me ]; then
		einfo "Setting /etc/nullmailer/me"
		/bin/hostname --fqdn > "${ROOT}"/etc/nullmailer/me
	fi
	if [ ! -s "${ROOT}"/etc/nullmailer/defaultdomain ]; then
		einfo "Setting /etc/nullmailer/defaultdomain"
		/bin/hostname --domain > "${ROOT}"/etc/nullmailer/defaultdomain
	fi
}
