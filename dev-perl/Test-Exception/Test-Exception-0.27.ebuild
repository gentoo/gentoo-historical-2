# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Exception/Test-Exception-0.27.ebuild,v 1.4 2008/11/18 15:35:47 tove Exp $

inherit perl-module

DESCRIPTION="test functions for exception based code"
HOMEPAGE="http://search.cpan.org/~adie/"
SRC_URI="mirror://cpan/authors/id/A/AD/ADIE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.28"

RDEPEND=">=virtual/perl-Test-Simple-0.64
	>=dev-perl/Sub-Uplevel-0.13
	dev-lang/perl"
