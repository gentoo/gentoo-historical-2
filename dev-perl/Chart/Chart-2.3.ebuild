# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Chart/Chart-2.3.ebuild,v 1.6 2005/01/21 20:17:10 mcummings Exp $

inherit perl-module

MY_P=${P/.3_/c-}
S=${WORKDIR}/${MY_P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl Chart Module"
SRC_URI="http://www.cpan.org/modules/by-module/Chart/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Chart/${MY_P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 ~amd64 ppc ~sparc ~alpha"
IUSE=""

DEPEND="${DEPEND}
	>=dev-perl/GD-1.2"

SRC_TEST="do"

mydoc="TODO"
