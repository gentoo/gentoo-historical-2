# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Nmap-Parser/Nmap-Parser-1.05.ebuild,v 1.2 2006/09/11 21:47:21 mcummings Exp $

inherit perl-module

DESCRIPTION="Nmap::Parser - parse nmap scan data with perl"
HOMEPAGE="http://search.cpan.org/dist/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AP/APERSAUD/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl
	perl-core/Storable
	>=dev-perl/XML-Twig-3.16"
RDEPEND="${DEPEND}"
