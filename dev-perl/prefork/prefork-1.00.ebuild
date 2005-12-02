# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/prefork/prefork-1.00.ebuild,v 1.4 2005/12/02 22:13:24 ferdy Exp $

inherit perl-module

DESCRIPTION="Optimized module loading for forking or non-forking processes"
HOMEPAGE="http://search.cpan.org/search?module=${PN}"
SRC_URI="mirror://cpan/authors/id/A/AD/ADAMK/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=perl-core/File-Spec-0.80
		>=dev-perl/Scalar-List-Utils-1.10"
