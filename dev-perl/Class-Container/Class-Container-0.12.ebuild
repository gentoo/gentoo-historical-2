# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Container/Class-Container-0.12.ebuild,v 1.3 2005/12/30 11:01:06 mcummings Exp $

inherit perl-module

DESCRIPTION="Class-Container module for perl"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~kwilliams/${P}"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc sparc x86"
IUSE=""

DEPEND="${DEPEND}
	dev-perl/module-build
	>=dev-perl/Params-Validate-0.24-r1
	>=perl-core/Scalar-List-Utils-1.08"
