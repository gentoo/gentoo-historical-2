# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-VecStat/Math-VecStat-0.08.ebuild,v 1.9 2007/01/19 14:06:52 mcummings Exp $

inherit perl-module

DESCRIPTION="Some basic numeric stats on vectors"
SRC_URI="mirror://cpan/authors/id/A/AS/ASPINELLI/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~aspinelli/Math-VecStat-0.08/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ia64 sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
