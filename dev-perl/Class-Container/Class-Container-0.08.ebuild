# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Container/Class-Container-0.08.ebuild,v 1.3 2002/12/15 10:44:12 bjb Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Class-Container module for perl"
SRC_URI="http://www.cpan.org/authors/id/K/KW/KWILLIAMS/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/M/MS/MSCHWERN/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="${DEPEND}
	>=dev-perl/Params-Validate-0.24-r1
	>=dev-perl/Scalar-List-Utils-1.08"
