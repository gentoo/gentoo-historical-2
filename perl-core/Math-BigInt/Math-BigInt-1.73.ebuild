# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Math-BigInt/Math-BigInt-1.73.ebuild,v 1.6 2006/07/05 19:59:08 ian Exp $

inherit perl-module

DESCRIPTION="Arbitrary size floating point math package"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/T/TE/TELS/math/${P}.readme"
SRC_URI="mirror://cpan/authors/id/T/TE/TELS/math/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc s390 sparc x86"
IUSE=""

DEPEND=">=virtual/perl-Scalar-List-Utils-1.14"
RDEPEND="${DEPEND}"

SRC_TEST="do"