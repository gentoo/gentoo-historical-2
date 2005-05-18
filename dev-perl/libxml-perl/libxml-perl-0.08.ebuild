# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libxml-perl/libxml-perl-0.08.ebuild,v 1.3 2005/05/18 09:53:09 corsair Exp $

inherit perl-module

DESCRIPTION="Collection of Perl modules for working with XML"
SRC_URI="mirror://cpan/modules/by-module/XML/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/modules/by-module/XML/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~ia64 ppc64"
IUSE=""

DEPEND="${DEPEND}
	>=dev-perl/XML-Parser-2.29"
