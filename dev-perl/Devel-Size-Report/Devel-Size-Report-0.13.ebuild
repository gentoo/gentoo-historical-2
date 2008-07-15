# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Size-Report/Devel-Size-Report-0.13.ebuild,v 1.2 2008/07/15 18:05:25 armin76 Exp $

inherit perl-module

DESCRIPTION="Generate a size report for all elements in a structure for perl"
HOMEPAGE="http://search.cpan.org/~tels/"
SRC_URI="mirror://cpan/authors/id/T/TE/TELS/devel/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ia64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/Devel-Size-0.59
	>=virtual/perl-Test-Simple-0.47
	>=virtual/perl-Scalar-List-Utils-1.13
	>=virtual/perl-Time-HiRes-1.52
	>=dev-perl/Array-RefElem-1.00
	dev-lang/perl"
