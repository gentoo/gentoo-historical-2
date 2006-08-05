# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-GMP/Math-GMP-2.04.ebuild,v 1.9 2006/08/05 14:00:41 mcummings Exp $

inherit perl-module

DESCRIPTION="High speed arbitrary size integer math"
SRC_URI="mirror://cpan/authors/id/C/CH/CHIPT/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~chipt/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
IUSE=""

DEPEND="dev-libs/gmp
	dev-lang/perl"
RDEPEND="${DEPEND}"


