# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Inline/Test-Inline-0.15.ebuild,v 1.3 2002/07/25 04:56:38 seemant Exp $

inherit perl-module

MY_P=Test-Inline-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Inline test suite support for Perl"
SRC_URI="http://www.cpan.org/modules/by-module/Test/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/search?dist=Test-Inline"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86"

DEPEND="${DEPEND}
	dev-perl/Memoize"

src_compile() {
	base_src_compile
	base_src_test || die "test failed"
}
