# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/logcheck/logcheck-1.3.7.ebuild,v 1.2 2010/03/10 09:55:55 josejx Exp $

inherit eutils

DESCRIPTION="Mails anomalies in the system logfiles to the administrator."
HOMEPAGE="http://packages.debian.org/sid/logcheck"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="!app-admin/logsentry
	app-misc/lockfile-progs
	dev-lang/perl
	dev-perl/mime-construct
	virtual/mailx
	${DEPEND}"

pkg_setup() {
	enewgroup logcheck
	enewuser logcheck -1 -1 -1 logcheck
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	keepdir /var/{lib,lock}/logcheck
	dodoc AUTHORS CHANGES CREDITS TODO docs/README.* || die "dodoc failed"
	doman docs/logtail.8 docs/logtail2.8 || die "doman failed"

	exeinto /etc/cron.hourly
	doexe "${FILESDIR}/${PN}.cron" || die "doexe failed"
}

pkg_postinst() {
	chown -R logcheck:logcheck /etc/logcheck /var/{lib,lock}/logcheck \
		|| die "chown failed"

	elog "The configuration files are located in /etc/logcheck. The most"
	elog "important files are /etc/logcheck/logcheck.conf"
	elog "and /etc/logcheck/logcheck.logfiles. Also, make sure that"
	elog "the logcheck user has access to your log files."
	elog "Finally, uncomment the logcheck line"
	elog "/etc/cron.hourly/logcheck.cron to enable periodic log checks."
}
