# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DT/XML-DT-0.20.ebuild,v 1.14 2003/06/21 21:36:44 drobbins Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A perl XML down translate module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/XML/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/XML/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="${DEPEND}
	>=dev-perl/XML-Parser-2.29"

src_install () {
	
	perl-module_src_install
	dohtml DT.html
}
