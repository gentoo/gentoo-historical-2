# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Vitaly Kushneriuk <vitaly_kushneriuk@yahoo.com>
# $Header: /var/cvsroot/gentoo-x86/net-mail/qmailanalog/qmailanalog-0.70.ebuild,v 1.1 2002/01/30 13:36:48 gbevin Exp $

S=${WORKDIR}/${P}

DESCRIPTION="collection of tools to help you analyze qmail's activity record."
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"
HOMEPAGE="http://cr.yp.to/qmailanalog.html"

DEPEND="virtual/glibc
		sys-apps/groff"

src_compile() {
	emake || die
	gcc ${FILESDIR}/tai64nfrac.c -o tai64nfrac
}

src_install () {
	into /usr
	doman matchup.1 xqp.1 xsender.1 xrecipient.1 columnt.1
	dodoc MATCHUP ACCOUNTING BLURB

	insopts -o root -g qmail -m 755
    insinto /var/qmail/bin
	into /var/qmail
	dobin columnt ddist deferrals failures matchup recipients rhosts
	dobin rxdelay senders successes suids xqp xrecipient xsender
	dobin zddist zdeferrals zfailures zoverall zrecipients zrhosts
	dobin zrxdelay zsenders zsendmail zsuccesses zsuids tai64nfrac
}
