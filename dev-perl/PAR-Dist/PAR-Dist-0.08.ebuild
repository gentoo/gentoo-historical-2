# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PAR-Dist/PAR-Dist-0.08.ebuild,v 1.4 2006/07/10 17:15:56 agriffis Exp $

inherit perl-module

DESCRIPTION="Create and manipulate PAR distributions"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/S/SM/SMUELLER/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="ia64 sparc ~x86"
IUSE=""

SRC_TEST="do"
