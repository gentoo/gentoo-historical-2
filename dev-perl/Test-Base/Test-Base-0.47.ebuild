# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Base/Test-Base-0.47.ebuild,v 1.2 2006/01/22 16:43:21 mcummings Exp $

inherit perl-module

DESCRIPTION="A Data Driven Testing Framework"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/I/IN/INGY/${P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~hppa ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=perl-core/Test-Simple-0.62
		>=dev-perl/Spiffy-0.26
		>=dev-lang/perl-5.6.1"
