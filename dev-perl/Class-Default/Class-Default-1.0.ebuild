# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Default/Class-Default-1.0.ebuild,v 1.14 2007/01/14 22:50:44 mcummings Exp $

inherit perl-module

DESCRIPTION="No description available."
SRC_URI="mirror://cpan/authors/id/A/AD/ADAMK/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~adamk"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ~mips ~ppc sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-perl/Class-Inspector
	virtual/perl-Test-Simple
	dev-lang/perl"
