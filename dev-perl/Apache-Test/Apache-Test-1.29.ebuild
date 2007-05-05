# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-Test/Apache-Test-1.29.ebuild,v 1.7 2007/05/05 17:30:20 dertobi123 Exp $

inherit perl-module

DESCRIPTION="Test.pm wrapper with helpers for testing Apache"
SRC_URI="mirror://cpan/authors/id/P/PG/PGOLLUCCI/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/Apache/"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 sparc x86"
SRC_TEST="skip"

DEPEND="net-www/apache
	dev-lang/perl"

src_install() {
	# This is to avoid conflicts with a deprecated Apache::Test stepping
	# in and causing problems/install errors
	if [ -f  ${S}/.mypacklist ];
	then
		rm -f ${S}/.mypacklist
	fi
	perl-module_src_install
}
