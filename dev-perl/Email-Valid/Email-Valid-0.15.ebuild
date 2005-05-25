# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Valid/Email-Valid-0.15.ebuild,v 1.12 2005/05/25 04:21:53 vapier Exp $

inherit perl-module

DESCRIPTION="Check validity of Internet email addresses."
SRC_URI="mirror://cpan/authors/id/M/MA/MAURICE/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/EMail/${P}.readme"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc64 sparc x86"
LICENSE="|| ( GPL-2 Artistic )"
IUSE=""
SRC_TEST="do"
DEPEND="${DEPEND}
	dev-perl/MailTools
	dev-perl/Net-DNS"
