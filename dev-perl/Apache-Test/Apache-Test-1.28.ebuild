# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-Test/Apache-Test-1.28.ebuild,v 1.2 2006/07/03 20:12:32 ian Exp $

inherit perl-module

DESCRIPTION="Test.pm wrapper with helpers for testing Apache"
SRC_URI="mirror://cpan/authors/id/G/GE/GEOFF/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/Apache/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
SRC_TEST="skip"
DEPEND="net-www/apache
		!>=www-apache/mod_perl-2"

src_install() {
	# This is to avoid conflicts with a deprecated Apache::Test stepping
	# in and causing problems/install errors
	if [ -f  ${S}/.mypacklist ];
	then
		rm -f ${S}/.mypacklist
	fi
	perl-module_src_install
}