# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/bignum/bignum-0.23.ebuild,v 1.9 2014/07/10 22:11:02 dilfridge Exp $

MODULE_AUTHOR=TELS
MODULE_SECTION=math
inherit perl-module

DESCRIPTION="Transparent BigNumber/BigRational support for Perl"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc s390 sh sparc x86"
IUSE="test"

SRC_TEST="do"
PREFER_BUILDPL="no"

RDEPEND=">=virtual/perl-Math-BigInt-1.88
	>=virtual/perl-Math-BigRat-0.21
	dev-lang/perl"
DEPEND="${RDEPEND}
	test? ( >=dev-perl/Test-Pod-Coverage-1.08 )"
