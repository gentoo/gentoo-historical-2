# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON-XS/JSON-XS-1.52.ebuild,v 1.1 2007/10/19 21:33:59 ian Exp $

inherit perl-module

DESCRIPTION="JSON::XS - JSON serialising/deserialising, done correctly and fast"
SRC_URI="mirror://cpan/authors/id/M/ML/MLEHMANN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~mlehmann/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
IUSE="test"
SRC_TEST="do"

DEPEND="dev-lang/perl
		test? ( virtual/perl-Test-Harness )"
