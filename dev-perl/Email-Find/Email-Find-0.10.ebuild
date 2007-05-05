# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Find/Email-Find-0.10.ebuild,v 1.4 2007/05/05 17:43:15 dertobi123 Exp $

inherit perl-module

DESCRIPTION="Find RFC 822 email addresses in plain text"
HOMEPAGE="http://search.cpan.org/~miyagawa/"
SRC_URI="mirror://cpan/authors/id/M/MI/MIYAGAWA/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ~ppc64 sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/MailTools
	dev-perl/Email-Valid
	virtual/perl-Test-Simple
	dev-lang/perl"
