# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Data-Inheritable/Class-Data-Inheritable-0.04.ebuild,v 1.8 2006/08/04 23:12:03 mcummings Exp $

inherit perl-module

DESCRIPTION="Exception::Class module for perl"
SRC_URI="mirror://cpan/authors/id/T/TM/TMTM/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~tmtm/${P}"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

export OPTIMIZE="${CFLAGS}"
DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
