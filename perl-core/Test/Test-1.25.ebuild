# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Test/Test-1.25.ebuild,v 1.3 2005/06/04 03:39:07 mcummings Exp $

inherit perl-module

DESCRIPTION="Utilities for writing test scripts"
HOMEPAGE="http://www.cpan.org/modules/by-authors/Test/${P}.readme"
SRC_URI="mirror://cpan/authors/id/S/SB/SBURKE/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ~ppc64 s390 sparc x86"
IUSE=""

DEPEND="perl-core/Test-Harness"

SRC_TEST="do"
