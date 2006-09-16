# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-StackTrace/Devel-StackTrace-1.13.ebuild,v 1.9 2006/09/16 20:52:35 dertobi123 Exp $

inherit perl-module

DESCRIPTION="Devel-StackTrace module for perl"
HOMEPAGE="http://www.perl.com/CPAN/modules/by-modules/Devel/Devel-StackTrace-1.12.readme"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/module-build-0.28
	dev-lang/perl"
RDEPEND="${DEPEND}"

OPTIMIZE="$CFLAGS"


