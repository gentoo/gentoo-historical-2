# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-RIPEMD160/Crypt-RIPEMD160-0.04.ebuild,v 1.13 2007/01/15 15:36:32 mcummings Exp $

inherit perl-module

DESCRIPTION="Crypt::RIPEMD160 module for perl"
HOMEPAGE="http://search.cpan.org/~chgeuer/"
SRC_URI="mirror://cpan/authors/id/C/CH/CHGEUER/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

export OPTIMIZE="$CFLAGS"
DEPEND="dev-lang/perl"
