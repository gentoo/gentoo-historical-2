# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Term-ProgressBar/Term-ProgressBar-2.09.ebuild,v 1.15 2009/05/19 21:03:09 ranger Exp $

inherit perl-module

DESCRIPTION="Perl module for Term-ProgressBar"
SRC_URI="mirror://cpan/authors/id/F/FL/FLUFFY/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~fluffy/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

RDEPEND="dev-perl/Class-MethodMaker
	dev-perl/TermReadKey
	dev-lang/perl"
DEPEND="${RDEPEND}
		>=virtual/perl-Module-Build-0.28"
