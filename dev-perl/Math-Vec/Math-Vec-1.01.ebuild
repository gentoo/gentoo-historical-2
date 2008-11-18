# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-Vec/Math-Vec-1.01.ebuild,v 1.2 2008/11/18 15:12:23 tove Exp $

inherit perl-module

DESCRIPTION="vectors for perl"
SRC_URI="mirror://cpan/authors/id/E/EW/EWILHELM/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~ewilhelm/Math-Vec/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl
	virtual/perl-Module-Build"
