# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Storable/Storable-2.12.ebuild,v 1.2 2004/06/25 01:00:15 agriffis Exp $

inherit perl-module

DESCRIPTION="The Perl Storable Module"
HOMEPAGE="http://www.cpan.org/modules/by-module/Storable/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/Storable/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~sparc ~mips ~alpha ~arm ~s390 ~ppc64"
IUSE=""

SRC_TEST="do"
