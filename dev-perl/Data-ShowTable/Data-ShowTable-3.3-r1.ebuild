# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-ShowTable/Data-ShowTable-3.3-r1.ebuild,v 1.6 2002/07/31 12:30:12 cselkirk Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="The Perl ShowTable Module"
SRC_URI="http://www.cpan.org/modules/by-module/Data/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Data/${P}.readme"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

mydoc="Copyright GNU-LICENSE"

src_install () {

	perl-module_src_install
	dohtml *.html
}
