# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sort-Versions/Sort-Versions-1.5.ebuild,v 1.3 2004/07/14 20:28:37 agriffis Exp $

inherit perl-module

DESCRIPTION="A perl 5 module for sorting of revision-like numbers"
HOMEPAGE="http://search.cpan.org/author/EDAVIS/${P}/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/E/ED/EDAVIS/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~mips ~s390"
IUSE=""

SRC_TEST="do"
