# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Slurp/File-Slurp-9999.12.ebuild,v 1.6 2006/08/05 03:52:07 mcummings Exp $

inherit perl-module

DESCRIPTION="Efficient Reading/Writing of Complete Files"
HOMEPAGE="http://search.cpan.org/~uri/${P}/"
SRC_URI="mirror://cpan/authors/id/U/UR/URI/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ia64 ~ppc sparc ~x86"
IUSE=""

SRC_TEST="do"

mydoc="extras/slurp_article.pod"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
