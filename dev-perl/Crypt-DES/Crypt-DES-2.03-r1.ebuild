# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-DES/Crypt-DES-2.03-r1.ebuild,v 1.9 2004/06/25 00:17:10 agriffis Exp $

inherit perl-module

DESCRIPTION="Crypt::DES module for perl"
HOMEPAGE="http://search.cpan.org/author/DPARIS/Crypt-DES-${PV}/"
SRC_URI="http://www.cpan.org/authors/id/D/DP/DPARIS/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ~mips"

DEPEND="virtual/glibc
	>=dev-lang/perl-5"

export OPTIMIZE="${CFLAGS}"
