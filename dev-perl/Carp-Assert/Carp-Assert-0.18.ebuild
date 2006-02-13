# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Carp-Assert/Carp-Assert-0.18.ebuild,v 1.7 2006/02/13 10:45:33 mcummings Exp $

inherit perl-module

DESCRIPTION="executable comments in carp"
HOMEPAGE="http://search.cpan.org/~mschwern/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHWERN/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/perl-Test-Simple"
