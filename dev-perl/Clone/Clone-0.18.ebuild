# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Clone/Clone-0.18.ebuild,v 1.9 2006/06/08 21:09:44 dertobi123 Exp $

inherit perl-module

DESCRIPTION="Recursively copy Perl datatypes"
SRC_URI="mirror://cpan/modules/by-authors/id/R/RD/RDF/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/R/RD/RDF/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND=""
