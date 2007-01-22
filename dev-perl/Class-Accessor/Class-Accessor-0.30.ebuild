# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Accessor/Class-Accessor-0.30.ebuild,v 1.4 2007/01/22 04:24:16 kloeri Exp $

inherit perl-module

DESCRIPTION="Automated accessor generation"
HOMEPAGE="http://search.cpan.org/~kasei/${P}/"
SRC_URI="mirror://cpan/authors/id/K/KA/KASEI/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~ppc ~ppc64 sparc ~x86"
IUSE=""
SRC_TEST="do"
DEPEND="dev-lang/perl"
