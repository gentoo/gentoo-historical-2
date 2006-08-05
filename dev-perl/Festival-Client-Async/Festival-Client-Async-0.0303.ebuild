# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Festival-Client-Async/Festival-Client-Async-0.0303.ebuild,v 1.11 2006/08/05 03:35:35 mcummings Exp $

inherit perl-module

DESCRIPTION="Festival-Async -  Non-blocking interface to a Festival server."
HOMEPAGE="http://search.cpan.org/~djhd/${P}/"
SRC_URI="mirror://cpan/authors/id/D/DJ/DJHD/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="ia64 sparc x86"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
