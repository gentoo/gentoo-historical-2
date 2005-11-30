# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-StrictHash/Tie-StrictHash-1.0.ebuild,v 1.1.1.1 2005/11/30 09:53:14 chriswhite Exp $

inherit perl-module

DESCRIPTION="A hash with strict-like semantics"
SRC_URI="mirror://cpan/authors/id/K/KV/KVAIL/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/K/KV/KVAIL/${P}.readme"
IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86"

SRC_TEST="do"
