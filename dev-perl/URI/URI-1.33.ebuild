# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/URI/URI-1.33.ebuild,v 1.6 2006/08/06 00:50:27 mcummings Exp $

inherit perl-module

DESCRIPTION="A URI Perl Module"
HOMEPAGE="http://search.cpan.org/~gaas/${P}/"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64 ~s390"
IUSE=""

DEPEND="virtual/perl-MIME-Base64
	dev-lang/perl"
RDEPEND="${DEPEND}"

mydoc="rfc2396.txt"

