# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SVG/SVG-2.33.ebuild,v 1.5 2006/08/05 20:24:58 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl extension for generating Scalable Vector Graphics (SVG) documents"
SRC_URI="mirror://cpan/authors/id/R/RO/RONAN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~ronan/${P}/"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha ~amd64 ia64 ~ppc sparc ~x86"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
