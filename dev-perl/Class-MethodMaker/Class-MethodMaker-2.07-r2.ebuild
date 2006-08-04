# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-MethodMaker/Class-MethodMaker-2.07-r2.ebuild,v 1.6 2006/08/04 23:29:44 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="Perl module for Class::MethodMaker"
HOMEPAGE="http://search.cpan.org/~fluffy/${MY_P}"
SRC_URI="mirror://cpan/authors/id/F/FL/FLUFFY/${P}.tar.gz"


LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"
PREFER_BUILDPL="no"


DEPEND=">=dev-perl/module-build-0.28
	dev-lang/perl"
RDEPEND="${DEPEND}"
