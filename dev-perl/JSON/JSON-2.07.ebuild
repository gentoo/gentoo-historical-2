# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON/JSON-2.07.ebuild,v 1.1 2008/03/24 14:17:44 hd_brummy Exp $

inherit perl-module

DESCRIPTION="parse and convert to JSON (JavaScript Object Notation)"
SRC_URI="http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~makamaka/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~sparc ~x86"

SRC_TEST="do"

DEPEND="dev-lang/perl"
