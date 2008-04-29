# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Table/HTML-Table-2.08.ebuild,v 1.1 2008/04/29 06:14:02 yuval Exp $

inherit perl-module

DESCRIPTION="produces HTML tables"
HOMEPAGE="http://search.cpan.org/~ajpeacock/"
SRC_URI="mirror://cpan/authors/id/A/AJ/AJPEACOCK/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
