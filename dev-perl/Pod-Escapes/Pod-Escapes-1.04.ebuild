# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-Escapes/Pod-Escapes-1.04.ebuild,v 1.4 2004/10/03 15:41:02 mcummings Exp $

inherit perl-module

CATEGORY="dev-perl"

DESCRIPTION="for resolving Pod E<...> sequences"
HOMEPAGE="http://search.cpan.org/~sburke/${P}"
SRC_URI="http://search.cpan.org/CPAN/authors/id/S/SB/SBURKE/${P}.tar.gz"

SRC_TEST="do"
LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc sparc ~alpha"
IUSE=""
