# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-DES/Crypt-DES-2.05.ebuild,v 1.13 2010/02/18 20:31:33 darkside Exp $

inherit perl-module

DESCRIPTION="Crypt::DES module for perl"
HOMEPAGE="http://search.cpan.org/~dparis/"
SRC_URI="mirror://cpan/authors/id/D/DP/DPARIS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=">=dev-lang/perl-5"

export OPTIMIZE="${CFLAGS}"
