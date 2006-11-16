# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pflogsumm/pflogsumm-1.1.0-r1.ebuild,v 1.1 2006/11/16 23:39:27 ticho Exp $

inherit eutils

DESCRIPTION="Pflogsumm is a log analyzer for Postfix logs"
HOMEPAGE="http://jimsun.linxnet.com/postfix_contrib.html"
SRC_URI="http://jimsun.linxnet.com/downloads/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

IUSE=""
KEYWORDS="x86 amd64"
DEPEND="dev-lang/perl
	dev-perl/Date-Calc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-postfix-2.3-logs.patch
}

src_install() {
	dodoc README ToDo ChangeLog pflogsumm-faq.txt
	doman pflogsumm.1
	dobin pflogsumm.pl
}
