# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Scalar-Properties/Scalar-Properties-0.12.ebuild,v 1.12 2007/01/19 15:42:01 mcummings Exp $

inherit perl-module

DESCRIPTION="run-time properties on scalar variables"
HOMEPAGE="http://search.cpan.org/~dcantrell/"
SRC_URI="mirror://cpan/authors/id/D/DC/DCANTRELL/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""
SRC_TEST="do"


DEPEND="dev-lang/perl"
