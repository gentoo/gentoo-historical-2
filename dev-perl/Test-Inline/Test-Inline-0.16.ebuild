# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Inline/Test-Inline-0.16.ebuild,v 1.7 2005/04/30 11:02:37 kloeri Exp $

inherit perl-module

MY_P=Test-Inline-${PV}
DESCRIPTION="Inline test suite support for Perl"
HOMEPAGE="http://search.cpan.org/search?dist=Test-Inline"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHWERN/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~hppa ~amd64"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Memoize
	dev-perl/Test-Harness
	dev-perl/Test-Simple"

S=${WORKDIR}/${MY_P}
