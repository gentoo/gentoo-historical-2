# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Clone/Clone-0.15.ebuild,v 1.3 2004/07/14 16:56:24 agriffis Exp $

inherit perl-module

DESCRIPTION="Recursively copy Perl datatypes"
SRC_URI="http://www.cpan.org/modules/by-authors/id/R/RD/RDF/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/R/RD/RDF/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~mips ~ppc ~sparc"
IUSE=""

SRC_TEST="do"

DEPEND=""
