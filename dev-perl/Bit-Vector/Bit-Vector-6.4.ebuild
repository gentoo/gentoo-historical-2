# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Bit-Vector/Bit-Vector-6.4.ebuild,v 1.3 2005/01/22 00:59:43 kloeri Exp $

inherit perl-module

DESCRIPTION="Efficient bit vector, set of integers and big int math library"
SRC_URI="mirror://cpan//authors/id/S/ST/STBEY/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~stbey/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~sparc ~alpha"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Carp-Clan"
