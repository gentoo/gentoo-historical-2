# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Template/HTML-Template-2.9.ebuild,v 1.4 2007/05/05 17:51:06 dertobi123 Exp $

inherit perl-module

DESCRIPTION="A Perl module to use HTML Templates"
HOMEPAGE="http://search.cpan.org/~samtregar/"
SRC_URI="mirror://cpan/authors/id/S/SA/SAMTREGAR/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1 GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""
SRC_TEST="do"

DEPEND="dev-lang/perl"
