# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sort-Versions/Sort-Versions-1.5.ebuild,v 1.15 2006/08/05 20:34:53 mcummings Exp $

inherit perl-module

DESCRIPTION="A perl 5 module for sorting of revision-like numbers"
HOMEPAGE="http://search.cpan.org/author/EDAVIS/${P}/"
SRC_URI="mirror://cpan/authors/id/E/ED/EDAVIS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
