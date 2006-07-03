# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-Test/Apache-Test-1.15.ebuild,v 1.10 2006/07/03 20:12:32 ian Exp $

inherit perl-module

DESCRIPTION="Test.pm wrapper with helpers for testing Apache"
SRC_URI="mirror://cpan/authors/id/G/GO/GOZER/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/Apache/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha ia64"
SRC_TEST="skip"
DEPEND="net-www/apache"
RDEPEND="${DEPEND}"

src_install() {
	# This is to avoid conflicts with a deprecated Apache::Test stepping
	# in and causing problems/install errors
	if [ -f  ${S}/.mypacklist ];
	then
		rm -f ${S}/.mypacklist
	fi
	perl-module_src_install
}
