# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-CSV_XS/Text-CSV_XS-0.30.ebuild,v 1.7 2007/11/10 14:54:42 drac Exp $

inherit perl-module

DESCRIPTION="comma-separated values manipulation routines"
SRC_URI="mirror://cpan/authors/id/H/HM/HMBRAND/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~hmbrand/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
