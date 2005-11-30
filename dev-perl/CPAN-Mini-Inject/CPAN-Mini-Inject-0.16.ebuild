# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Mini-Inject/CPAN-Mini-Inject-0.16.ebuild,v 1.1 2005/03/08 18:26:49 mcummings Exp $

inherit perl-module

DESCRIPTION="Inject modules into a CPAN::Mini mirror. "
HOMEPAGE="http://search.cpan.org/~ssoriche/${P}/"
SRC_URI="mirror://cpan/authors/id/S/SS/SSORICHE/${P}.tar.gz"

LICENSE="Artistic"
#LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/libwww-perl
		>=dev-perl/CPAN-Mini-0.32
		dev-perl/CPAN-Checksums"
