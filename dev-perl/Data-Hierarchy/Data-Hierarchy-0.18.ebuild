# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Hierarchy/Data-Hierarchy-0.18.ebuild,v 1.2 2004/06/25 00:20:28 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Data::Hierarchy - Handle data in a hierarchical structure"
SRC_URI="http://www.cpan.org/modules/by-module/Data/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Data/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~mips ~ppc ~sparc ~x86"

SRC_TEST="do"

DEPEND="${DEPEND}
	dev-perl/Clone"
