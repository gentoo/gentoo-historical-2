# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Stream/XML-Stream-1.21.ebuild,v 1.2 2004/06/25 01:14:22 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Creates and XML Stream connection and parses return data"
SRC_URI="http://cpan.valueclick.com/authors/id/R/RE/REATMON/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~reatmon/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha"

SRC_TEST="do"

DEPEND="dev-perl/Authen-SASL
	dev-perl/Net-DNS
	ssl? ( dev-perl/IO-Socket-SSL )
	dev-perl/MIME-Base64"
