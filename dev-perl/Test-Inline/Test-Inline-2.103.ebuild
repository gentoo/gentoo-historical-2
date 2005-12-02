# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Inline/Test-Inline-2.103.ebuild,v 1.2 2005/12/02 09:23:26 josejx Exp $

inherit perl-module

MY_P=Test-Inline-${PV}
DESCRIPTION="Inline test suite support for Perl"
HOMEPAGE="http://search.cpan.org/search?dist=Test-Inline"
SRC_URI="mirror://cpan/authors/id/A/AD/ADAMK/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="perl-core/Test-Simple
	>=dev-perl/Test-ClassAPI-1.02"
RDEPEND="perl-core/Memoize
	perl-core/Test-Harness
	>=perl-core/File-Spec-0.80
	>=dev-perl/File-Slurp-9999.04
	>=dev-perl/File-Find-Rule-0.26
	>=dev-perl/Config-Tiny-2.00
	>=dev-perl/Params-Util-0.05
	>=dev-perl/Class-Autouse-1.15
	>=dev-perl/Algorithm-Dependency-1.02
	>=dev-perl/File-Flat-0.95
	>=dev-perl/Pod-Tests-0.18"

S=${WORKDIR}/${MY_P}
