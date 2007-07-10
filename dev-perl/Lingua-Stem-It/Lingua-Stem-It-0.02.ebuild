# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-Stem-It/Lingua-Stem-It-0.02.ebuild,v 1.2 2007/07/10 23:33:26 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="Porter's stemming algorithm for Italian"
HOMEPAGE="http://search.cpan.org/~acalpini/"
SRC_URI="mirror://cpan/authors/id/A/AC/ACALPINI/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
