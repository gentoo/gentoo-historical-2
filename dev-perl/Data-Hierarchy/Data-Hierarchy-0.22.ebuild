# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Hierarchy/Data-Hierarchy-0.22.ebuild,v 1.6 2006/10/15 10:03:27 kloeri Exp $

inherit perl-module

DESCRIPTION="Data::Hierarchy - Handle data in a hierarchical structure"
SRC_URI="mirror://cpan/authors/id/C/CL/CLKAO/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Data/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha amd64 ia64 ~mips ~ppc sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Clone
	dev-lang/perl"
