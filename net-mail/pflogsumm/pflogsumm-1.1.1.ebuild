# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pflogsumm/pflogsumm-1.1.1.ebuild,v 1.4 2008/08/22 22:39:36 maekke Exp $

inherit eutils

DESCRIPTION="Pflogsumm is a log analyzer for Postfix logs"
HOMEPAGE="http://jimsun.linxnet.com/postfix_contrib.html"
SRC_URI="http://jimsun.linxnet.com/downloads/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

IUSE=""
KEYWORDS="amd64 sparc x86"
DEPEND="dev-lang/perl
		dev-perl/Date-Calc"

src_install() {
	dodoc README ToDo ChangeLog pflogsumm-faq.txt
	doman pflogsumm.1
	dobin pflogsumm.pl
}
