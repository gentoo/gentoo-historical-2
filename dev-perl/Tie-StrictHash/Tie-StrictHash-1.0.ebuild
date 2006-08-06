# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-StrictHash/Tie-StrictHash-1.0.ebuild,v 1.5 2006/08/06 00:35:05 mcummings Exp $

inherit perl-module

DESCRIPTION="A hash with strict-like semantics"
SRC_URI="mirror://cpan/authors/id/K/KV/KVAIL/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/K/KV/KVAIL/${P}.readme"
IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="ia64 x86"

SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
