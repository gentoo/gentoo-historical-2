# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Simple/XML-Simple-2.14.ebuild,v 1.4 2006/01/13 22:38:52 mcummings Exp $

inherit perl-module

IUSE=""
DESCRIPTION="XML::Simple - Easy API to read/write XML (esp config files)"
SRC_URI="mirror://cpan/authors/id/G/GR/GRANTM/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/XML/${P}.readme"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 sparc x86"

SRC_TEST="do"

DEPEND="${DEPEND}
	perl-core/Storable
	dev-perl/XML-SAX
	>=dev-perl/XML-NamespaceSupport-1.04
	>=dev-perl/XML-Parser-2.30"
