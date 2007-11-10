# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Math-BigRat/Math-BigRat-0.19.ebuild,v 1.8 2007/11/10 11:19:46 drac Exp $

inherit perl-module

DESCRIPTION="Arbitrary big rational numbers"
HOMEPAGE="http://search.cpan.org/~tels"
SRC_URI="mirror://cpan/authors/id/T/TE/TELS/math/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ~ppc s390 sh sparc x86"
IUSE=""

SRC_TEST="do"
PREFER_BUILDPL="no"

DEPEND=">=perl-core/Math-BigInt-1.83
	dev-lang/perl"
