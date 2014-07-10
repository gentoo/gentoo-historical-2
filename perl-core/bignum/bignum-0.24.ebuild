# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/bignum/bignum-0.24.ebuild,v 1.2 2014/07/10 14:20:17 dilfridge Exp $

EAPI=3

MODULE_AUTHOR=FLORA
inherit perl-module

DESCRIPTION="Transparent BigNumber/BigRational support for Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE="test"

RDEPEND=">=virtual/perl-Math-BigInt-1.88
	>=perl-core/Math-BigRat-0.21"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		>=dev-perl/Test-Pod-Coverage-1.08 )"

SRC_TEST="do"
