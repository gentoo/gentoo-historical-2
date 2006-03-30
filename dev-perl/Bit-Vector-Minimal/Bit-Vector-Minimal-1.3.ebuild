# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Bit-Vector-Minimal/Bit-Vector-Minimal-1.3.ebuild,v 1.4 2006/03/30 22:12:35 agriffis Exp $

inherit perl-module

DESCRIPTION="Object-oriented wrapper around vec()"
HOMEPAGE="http://search.cpan.org/~simon/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TM/TMTM/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 ppc sparc x86"
IUSE=""

SRC_TEST="do"
