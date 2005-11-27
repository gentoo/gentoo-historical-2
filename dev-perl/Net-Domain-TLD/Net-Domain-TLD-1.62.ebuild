# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Domain-TLD/Net-Domain-TLD-1.62.ebuild,v 1.2 2005/11/27 22:13:19 tgall Exp $

inherit perl-module

DESCRIPTION="Gives ability to retrieve currently available tld names/descriptions and perform verification of given tld name"
HOMEPAGE="http://search.cpan.org/~rjbs/${P}/"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 sparc alpha amd64 hppa ia64 ppc ppc64"
IUSE=""

TDEPEND=">=dev-perl/Test-Pod-Coverage-1.04"

SRC_TEST="do"
