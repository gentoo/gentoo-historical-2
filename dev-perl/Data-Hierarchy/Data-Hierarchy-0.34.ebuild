# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Hierarchy/Data-Hierarchy-0.34.ebuild,v 1.6 2010/01/09 19:24:44 grobian Exp $

inherit perl-module

DESCRIPTION="Data::Hierarchy - Handle data in a hierarchical structure"
SRC_URI="mirror://cpan/authors/id/C/CL/CLKAO/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Data/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ia64 ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Clone
	dev-perl/Test-Exception
	dev-lang/perl"
