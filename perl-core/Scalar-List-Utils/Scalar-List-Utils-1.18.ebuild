# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Scalar-List-Utils/Scalar-List-Utils-1.18.ebuild,v 1.10 2006/08/04 13:30:11 mcummings Exp $

inherit perl-module

DESCRIPTION="Scalar-List-Utils module for perl"
HOMEPAGE="http://cpan.org/modules/by-module/Scalar/"
SRC_URI="mirror://cpan/authors/id/G/GB/GBARR/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
