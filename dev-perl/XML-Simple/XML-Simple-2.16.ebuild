# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Simple/XML-Simple-2.16.ebuild,v 1.11 2007/05/05 18:11:45 dertobi123 Exp $

inherit perl-module

DESCRIPTION="XML::Simple - Easy API to read/write XML (esp config files)"
HOMEPAGE="http://search.cpan.org/~grantm/"
SRC_URI="mirror://cpan/authors/id/G/GR/GRANTM/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/perl-Storable
	dev-perl/XML-SAX
	dev-perl/XML-LibXML
	>=dev-perl/XML-NamespaceSupport-1.04
	>=dev-perl/XML-Parser-2.30
	dev-lang/perl
	>=virtual/perl-Test-Simple-0.41"

SRC_TEST="do"
