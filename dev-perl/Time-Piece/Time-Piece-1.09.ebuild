# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Time-Piece/Time-Piece-1.09.ebuild,v 1.2 2006/06/12 16:53:01 mcummings Exp $

inherit perl-module

DESCRIPTION="Object Oriented time objects"
HOMEPAGE="http://search.cpan.org/~msergeant/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSERGEANT/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc sparc ~x86"
IUSE=""

SRC_TEST="do"
