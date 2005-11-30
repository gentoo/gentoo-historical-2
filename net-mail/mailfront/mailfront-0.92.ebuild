# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailfront/mailfront-0.92.ebuild,v 1.1 2005/02/13 06:37:26 robbat2 Exp $

inherit fixheadtails gcc

DESCRIPTION="Mail server network protocol front-ends"
HOMEPAGE="http://untroubled.org/mailfront/"
SRC_URI="http://untroubled.org/mailfront/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"
IUSE=""

DEPEND="virtual/libc
	>=dev-libs/bglibs-1.017"
RDEPEND="mail-mta/qmail
	 net-mail/cvm-vmailmgr"
# when the new cvm ebuild is in portage we would want something like
#	( net-mail/cvm-vmailmgr || ( >=dev-libs/cvm-0.31 ) )"

src_unpack() {
	unpack ${A}
	ht_fix_file ${S}/Makefile
}

src_compile() {
	echo "/usr/lib/bglibs/include" > conf-bgincs
	echo "/usr/lib/bglibs/lib" > conf-bglibs
	echo "/var/qmail/bin" > conf-bin
	echo "/var/qmail" > conf-qmail
	echo "$(gcc-getCC) ${CFLAGS}" > conf-cc
	echo "$(gcc-getCC) -s" > conf-ld
	emake || die
}

src_install() {
	exeinto /var/qmail/bin
	doexe pop3front-auth pop3front-maildir smtpfront-echo \
		smtpfront-qmail smtpfront-reject imapfront-auth \
		qmqpfront-qmail qmtpfront-qmail || die

	#install new run files for qmail-smtpd and qmail-pop3
	exeinto /var/qmail/supervise/qmail-smtpd
	newexe ${FILESDIR}/run-smtpfront run.mailfront
	exeinto /var/qmail/supervise/qmail-pop3d
	newexe ${FILESDIR}/run-pop3front run.mailfront

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION COPYING

	dohtml cvm-sasl.html imapfront.html mailfront.html mailrules.html \
		mailrules2.html pop3front.html qmail-backend.html patterns.html \
		qmail-validate.html smtpfront.html
}

pkg_config() {
	cd /var/qmail/supervise/qmail-smtpd/
	cp run run.qmail-smtpd.`date +%Y%m%d%H%M%S` && cp run.mailfront run
	cd /var/qmail/supervise/qmail-pop3d/
	cp run run.qmail-pop3d.`date +%Y%m%d%H%M%S` && cp run.mailfront run
}

pkg_postinst() {
	einfo ""
	einfo "Run ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo "to update you run files (backups are created) in"
	einfo "		/var/qmail/supervise/qmail-pop3d and"
	einfo "		/var/qmail/supervise/qmail-smtpd"
}
