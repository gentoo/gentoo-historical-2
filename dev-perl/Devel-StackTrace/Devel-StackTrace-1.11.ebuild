# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-StackTrace/Devel-StackTrace-1.11.ebuild,v 1.4 2004/09/03 17:14:17 pvdabeel Exp $

inherit perl-module

DESCRIPTION="Devel-StackTrace module for perl"
HOMEPAGE="http://www.perl.com/CPAN/modules/by-modules/Devel/${P}.readme"
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc ~alpha ~hppa ~amd64"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/Test-Simple-0.47"

export OPTIMIZE="$CFLAGS"
