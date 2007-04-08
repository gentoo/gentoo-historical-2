# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-SPF-Query/Mail-SPF-Query-1.999.1.ebuild,v 1.11 2007/04/08 12:38:28 ticho Exp $

inherit perl-module

DESCRIPTION="query Sender Policy Framework for an IP,email,helo"
SRC_URI="mirror://cpan/authors/id/J/JM/JMEHNLE/mail-spf-query/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~JMEHNLE/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc64 sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/Net-DNS-0.46
	>=dev-perl/Net-CIDR-Lite-0.15
		dev-perl/Sys-Hostname-Long
		dev-perl/URI
	dev-lang/perl"

mydoc="TODO README sample/*"

