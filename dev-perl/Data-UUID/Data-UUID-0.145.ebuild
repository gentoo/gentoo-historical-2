# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-UUID/Data-UUID-0.145.ebuild,v 1.4 2006/11/24 17:06:18 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl extension for generating Globally/Universally Unique
Identifiers (GUIDs/UUIDs)."
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
SRC_TEST="do"

DEPEND="dev-lang/perl
	test? ( dev-perl/Test-Pod-Coverage
		dev-perl/Test-Pod )"
