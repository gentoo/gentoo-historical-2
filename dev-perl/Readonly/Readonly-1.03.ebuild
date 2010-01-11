# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Readonly/Readonly-1.03.ebuild,v 1.8 2010/01/11 19:20:29 grobian Exp $

inherit perl-module

DESCRIPTION="Facility for creating read-only scalars, arrays, hashes"
SRC_URI="mirror://cpan/authors/id/R/RO/ROODE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/dist/Readonly/Readonly.pm"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
