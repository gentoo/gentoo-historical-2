# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/cronie/cronie-1.4.8-r1.ebuild,v 1.4 2012/04/06 18:26:25 swift Exp $

EAPI="3"

inherit cron eutils pam

DESCRIPTION="Cronie is a standard UNIX daemon cron based on the original vixie-cron."
SRC_URI="https://fedorahosted.org/releases/c/r/cronie/${P}.tar.gz"
HOMEPAGE="https://fedorahosted.org/cronie/wiki"

LICENSE="ISC BSD BSD-2"
KEYWORDS="~amd64 ~arm ~sparc ~x86"
IUSE="anacron inotify pam selinux"

DEPEND="pam? ( virtual/pam )
	anacron? ( !sys-process/anacron )"
RDEPEND="${DEPEND}"

#cronie supports /etc/crontab
CRON_SYSTEM_CRONTAB="yes"

pkg_setup() {
	enewgroup crontab
}

src_configure() {
	SPOOL_DIR="/var/spool/cron/crontabs" econf \
		$(use_with inotify ) \
		$(use_with pam ) \
		$(use_with selinux ) \
		$(use_enable anacron ) \
		--with-daemon_username=cron \
		--with-daemon_groupname=cron \
		|| die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"

	docrondir -m 1730 -o root -g crontab
	fowners root:crontab /usr/bin/crontab
	fperms 2751 /usr/bin/crontab

	insinto /etc/conf.d
	newins "${S}"/crond.sysconfig ${PN}

	insinto /etc
	newins "${FILESDIR}/${PN}-1.2-crontab" crontab
	newins "${FILESDIR}/${PN}-1.2-cron.deny" cron.deny

	keepdir /etc/cron.d
	newinitd "${FILESDIR}/${PN}-1.3-initd" ${PN}
	newpamd "${FILESDIR}/${PN}-1.4.3-pamd" crond

	if use anacron ; then
		#insinto /etc/cron.daily
		#doins "${S}"/contrib/0anacron
		#fperms 0755 /etc/cron.daily/0anacron

		keepdir /var/spool/anacron
		fowners root:cron /var/spool/anacron
		fperms 0750 /var/spool/anacron

		insinto /etc

		newinitd "${FILESDIR}"/anacron-1.0-initd anacron
	fi

	dodoc AUTHORS README contrib/*
}

pkg_postinst() {
	cron_pkg_postinst
}
