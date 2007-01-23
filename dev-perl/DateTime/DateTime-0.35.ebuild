# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime/DateTime-0.35.ebuild,v 1.7 2007/01/23 00:56:57 kloeri Exp $

inherit perl-module

DESCRIPTION="A date and time object"
HOMEPAGE="http://search.cpan.org/~drolsky/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/Params-Validate-0.76
	>=virtual/perl-Time-Local-1.04
		>=dev-perl/DateTime-TimeZone-0.27
		>=dev-perl/DateTime-Locale-0.21
	dev-lang/perl"
