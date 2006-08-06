# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-String/Unicode-String-2.06-r2.ebuild,v 1.13 2006/08/06 00:53:12 mcummings Exp $

inherit perl-module

DESCRIPTION="A Unicode Perl Module"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~gaas/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""

DEPEND=">=virtual/perl-MIME-Base64-2.11
	dev-lang/perl"
RDEPEND="${DEPEND}"

