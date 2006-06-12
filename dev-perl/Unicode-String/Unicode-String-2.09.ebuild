# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-String/Unicode-String-2.09.ebuild,v 1.4 2006/06/12 16:55:24 mcummings Exp $

inherit perl-module

DESCRIPTION="String manipulation for Unicode strings"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~gaas/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86"
IUSE=""

DEPEND="${DEPEND}
	>=virtual/perl-MIME-Base64-2.11"
