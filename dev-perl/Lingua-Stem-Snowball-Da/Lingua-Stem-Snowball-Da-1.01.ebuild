# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-Stem-Snowball-Da/Lingua-Stem-Snowball-Da-1.01.ebuild,v 1.6 2006/07/01 01:07:20 mcummings Exp $

inherit perl-module

DESCRIPTION="Porters stemming algorithm for Denmark"
HOMEPAGE="http://search.cpan.org/~cine/${P}/"
SRC_URI="mirror://cpan/authors/id/C/CI/CINE/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"
