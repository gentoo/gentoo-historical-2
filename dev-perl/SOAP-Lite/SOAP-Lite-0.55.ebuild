# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header $

IUSE=""

inherit perl-module

MY_P=SOAP-Lite-${PV}
S=${WORKDIR}/${P}
DESCRIPTION="Provides a simple and lightweight interface to the SOAP protocol (sic) both on client and server side."

SRC_URI="http://cpan.valueclick.com/modules/by-module/SOAP/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/SOAP/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND="${DEPEND}
	dev-perl/XML-Parser
	dev-perl/MIME-Lite
	dev-perl/MIME-tools"

src_compile() {
	(echo yes) | perl-module_src_compile || perl-module_src_compile || die "compile failed"
	perl-module_src_test || die "test failed"
}
