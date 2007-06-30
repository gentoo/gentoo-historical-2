# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-CBuilder/ExtUtils-CBuilder-0.19.ebuild,v 1.3 2007/06/30 01:53:49 kumba Exp $

inherit perl-module

DESCRIPTION="Compile and link C code for Perl modules"
HOMEPAGE="http://search.cpan.org/~kwilliams/"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-perl/module-build
	dev-lang/perl"

SRC_TEST="do"
