# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-CIDR-Lite/Net-CIDR-Lite-0.15.ebuild,v 1.11 2006/08/05 14:08:31 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl extension for merging IPv4 or IPv6 CIDR addresses "
SRC_URI="mirror://cpan/authors/id/D/DO/DOUGW/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~dougw/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ppc ppc64 sparc x86"
IUSE=""

mydoc="TODO"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
