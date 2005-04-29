# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/spamassassin-ruledujour/spamassassin-ruledujour-20050106.ebuild,v 1.4 2005/04/29 22:48:59 robbat2 Exp $

DESCRIPTION="SpamAssassin - Rules Du Jour & My Rules Du Jour"
HOMEPAGE="http://www.exit0.us/index.php/RulesDuJour http://www.rulesemporium.com/rules.htm"
SRC_URI="mirror://gentoo/${P}.tar.bz2 http://dev.gentoo.org/~robbat2/distfiles/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""
DEPEND="" # this is correct!
RDEPEND="app-shells/bash
		 mail-filter/spamassassin
		 || ( net-misc/wget net-misc/curl )
		 sys-apps/grep
		 sys-apps/sed
		 dev-lang/perl
		 sys-apps/coreutils
		 virtual/cron
		 virtual/mailx"

SPAMASSASSIN_CONFDIR=/etc/mail/spamassassin
SPAMASSASSIN_LIBDIR=/var/lib/spamassassin

src_install() {
	keepdir $SPAMASSASSIN_CONFDIR $SPAMASSASSIN_LIBDIR

	# new config files
	insinto /etc/rulesdujour
	doins bin/config bin/rulesets

	# rules_du_jour itself
	exeinto ${SPAMASSASSIN_LIBDIR}

	doexe bin/rules_du_jour

	# some spamassassin rules
	insinto $SPAMASSASSIN_CONFDIR
	doins rules/*

	insinto /etc/cron.daily
	# new cronjob
	newins cron-rulesdujour rulesdujour
	fperms 644 /etc/cron.daily/rulesdujour
	# my_rules_du_jour is deprecated, but be gentle about it
	if [ -f "${ROOT}/etc/cron.daily/myrulesdujour" ]; then
		newins cron-myrulesdujour myrulesdujour
		fperms 644 /etc/cron.daily/myrulesdujour
	fi
}

pkg_postinst() {
	einfo "If you want RulesDuJour to run automatically, be sure to:"
	einfo "chmod +x /etc/cron.daily/rulesdujour"
	[ -f "${ROOT}/etc/cron.daily/myrulesdujour" ] && einfo "my_rules_du_jour is deprecated by upstream now, please remove the old cronjob if applicable"

	einfo "It is also recommended that you clean out your rulesets in"
	einfo "$SPAMASSASSIN_CONFDIR ocassionally, to ensure that old rules"
	einfo "are not being used."
}
