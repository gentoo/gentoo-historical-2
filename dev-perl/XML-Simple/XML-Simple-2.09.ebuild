# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Simple/XML-Simple-2.09.ebuild,v 1.11 2006/02/13 14:14:44 mcummings Exp $

inherit perl-module

IUSE=""
DESCRIPTION="XML::Simple - Easy API to read/write XML (esp config files)"
SRC_URI="http://www.cpan.org/modules/by-module/XML/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/XML/${P}.readme"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="${DEPEND}
	virtual/perl-Storable
	virtual/perl-Test-Simple
	dev-perl/XML-SAX
	dev-perl/XML-NamespaceSupport
	>=dev-perl/XML-Parser-2.30"
