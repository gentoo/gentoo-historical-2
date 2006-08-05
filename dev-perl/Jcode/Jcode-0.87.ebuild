# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Jcode/Jcode-0.87.ebuild,v 1.13 2006/08/05 04:59:56 mcummings Exp $

inherit perl-module

MY_P=Jcode-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Japanese transcoding module for Perl"
SRC_URI="http://cpan.org/modules/by-authors/id/D/DA/DANKOGAI/${MY_P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-authors/id/D/DA/DANKOGAI/${MY_P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~ppc ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=virtual/perl-MIME-Base64-2.1
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}

