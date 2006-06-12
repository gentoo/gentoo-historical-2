# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Base/Test-Base-0.46.ebuild,v 1.5 2006/06/12 16:47:15 mcummings Exp $

inherit perl-module

DESCRIPTION="A Data Driven Testing Framework"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/I/IN/INGY/${P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~hppa ~ppc sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=virtual/perl-Test-Simple-0.62
		>=dev-perl/Spiffy-0.26
		>=dev-lang/perl-5.6.1"
