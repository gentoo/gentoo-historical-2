# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Harness/Test-Harness-2.24.ebuild,v 1.13 2004/02/24 10:39:03 kumba Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Runs perl standard test scripts with statistics"
SRC_URI="http://www.cpan.org/authors/id/MSCHWERN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/search?dist=Test-Harness"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"

mydoc="rfc*.txt"

src_compile() {
	perl-module_src_compile
	perl-module_src_test || die "test failed"
}
