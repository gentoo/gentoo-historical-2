# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Pod-Coverage/Test-Pod-Coverage-1.08.ebuild,v 1.16 2007/04/24 08:57:54 kloeri Exp $

inherit perl-module

DESCRIPTION="Check for pod coverage in your distribution"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~petdance/"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"

DEPEND=">=virtual/perl-Test-Simple-0.62
	dev-perl/Pod-Coverage
	dev-lang/perl"
