# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-PT-Stemmer/Lingua-PT-Stemmer-0.01.ebuild,v 1.8 2006/08/05 13:25:49 mcummings Exp $

inherit perl-module

DESCRIPTION="Portuguese language stemming"
HOMEPAGE="http://search.cpan.org/~xern/${P}/"
SRC_URI="mirror://cpan/authors/id/X/XE/XERN/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
