# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SNPP/Net-SNPP-1.17.ebuild,v 1.10 2006/03/30 23:07:34 agriffis Exp $

inherit perl-module

DESCRIPTION="libnet SNPP component"
SRC_URI="mirror://cpan/authors/id/T/TO/TOBEYA/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~tobeya/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~ia64 ~ppc sparc x86"
IUSE=""

DEPEND="perl-core/libnet"
