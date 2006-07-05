# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Stream/XML-Stream-1.21.ebuild,v 1.8 2006/07/05 13:56:33 ian Exp $

inherit perl-module

DESCRIPTION="Creates and XML Stream connection and parses return data"
SRC_URI="mirror://cpan/authors/id/R/RE/REATMON/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~reatmon/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ppc ~sparc ~x86"
IUSE="ssl"

SRC_TEST="do"

DEPEND="dev-perl/Authen-SASL
	dev-perl/Net-DNS
	ssl? ( dev-perl/IO-Socket-SSL )
	virtual/perl-MIME-Base64"
RDEPEND="${DEPEND}"