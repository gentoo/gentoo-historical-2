# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Simple/XML-Simple-2.15.ebuild,v 1.1 2006/10/03 08:47:32 ian Exp $

inherit perl-module

DESCRIPTION="XML::Simple - Easy API to read/write XML (esp config files)"
HOMEPAGE="http://www.cpan.org/modules/by-module/XML/${P}.readme"
SRC_URI="mirror://cpan/authors/id/G/GR/GRANTM/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="virtual/perl-Storable
	dev-perl/XML-SAX
	>=dev-perl/XML-NamespaceSupport-1.04
	>=dev-perl/XML-Parser-2.30
	dev-lang/perl
	>=perl-core/Test-Simple-0.41"
RDEPEND="${DEPEND}"
