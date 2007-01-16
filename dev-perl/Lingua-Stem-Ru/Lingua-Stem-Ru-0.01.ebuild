# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-Stem-Ru/Lingua-Stem-Ru-0.01.ebuild,v 1.10 2007/01/16 01:17:32 mcummings Exp $

inherit perl-module

DESCRIPTION="Porter's stemming algorithm for Russian (KOI8-R only)"
HOMEPAGE="http://search.cpan.org/~algdr/"
SRC_URI="mirror://cpan/authors/id/A/AL/ALGDR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
