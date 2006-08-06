# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libintl-perl/libintl-perl-1.10.ebuild,v 1.8 2006/08/06 02:43:19 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl internationalization library that aims to be compatible with the Uniforum message translations system"
HOMEPAGE="http://search.cpan.org/~guido/${P}/"
SRC_URI="mirror://cpan/authors/id/G/GU/GUIDO/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
