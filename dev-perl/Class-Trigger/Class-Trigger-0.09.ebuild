# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Trigger/Class-Trigger-0.09.ebuild,v 1.5 2006/02/13 10:57:11 mcummings Exp $

inherit perl-module

DESCRIPTION="Mixin to add / call inheritable triggers"
HOMEPAGE="http://search.cpan.org/~miyagawa/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MI/MIYAGAWA/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="virtual/perl-Test-Simple
		dev-perl/IO-stringy
		dev-perl/Class-Data-Inheritable"
