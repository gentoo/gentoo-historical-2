# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Math-BigInt/Math-BigInt-1.87.ebuild,v 1.6 2008/03/28 06:52:38 jer Exp $

inherit perl-module eutils

DESCRIPTION="Arbitrary size floating point math package"
HOMEPAGE="http://search.cpan.org/~tels/"
SRC_URI="mirror://cpan/authors/id/T/TE/TELS/math/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc s390 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl
		>=virtual/perl-Scalar-List-Utils-1.14"

PDEPEND=">=perl-core/bignum-0.21
		>=perl-core/Math-BigRat-0.19"

SRC_TEST="do"
PREFER_BUILDPL="no"
