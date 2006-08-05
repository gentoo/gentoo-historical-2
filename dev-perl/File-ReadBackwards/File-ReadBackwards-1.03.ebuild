# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-ReadBackwards/File-ReadBackwards-1.03.ebuild,v 1.5 2006/08/05 03:44:40 mcummings Exp $

inherit perl-module

DESCRIPTION="The Perl File-ReadBackwards Module"
SRC_URI="mirror://cpan/authors/id/U/UR/URI/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/File/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ppc64 sparc x86"
SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
