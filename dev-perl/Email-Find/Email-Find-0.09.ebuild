# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Find/Email-Find-0.09.ebuild,v 1.10 2005/05/08 11:35:53 nigoro Exp $

inherit perl-module

DESCRIPTION="Find RFC 822 email addresses in plain text"
HOMEPAGE="http://search.cpan.org/~miyagawa/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MI/MIYAGAWA/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86 ~ppc64"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/MailTools
	dev-perl/Email-Valid
	dev-perl/Test-Simple"
