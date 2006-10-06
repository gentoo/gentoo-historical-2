# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libintl-perl/libintl-perl-1.16.ebuild,v 1.7 2006/10/06 21:59:14 wolf31o2 Exp $

inherit perl-module

DESCRIPTION="Perl internationalization library that aims to be compatible with the Uniforum message translations system"
HOMEPAGE="http://search.cpan.org/~guido/${P}/"
SRC_URI="mirror://cpan/authors/id/G/GU/GUIDO/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
