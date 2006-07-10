# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-XWhois/Net-XWhois-0.90.ebuild,v 1.4 2006/07/10 17:10:39 agriffis Exp $

inherit perl-module

DESCRIPTION="Manipulate netblock lists in CIDR notation"
SRC_URI="mirror://cpan/authors/id/V/VI/VIPUL/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/dist/Net-XWhois/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="ia64 sparc x86"
IUSE=""

SRC_TEST="do"

mydoc="examples/*"
