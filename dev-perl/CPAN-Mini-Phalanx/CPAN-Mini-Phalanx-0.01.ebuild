# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Mini-Phalanx/CPAN-Mini-Phalanx-0.01.ebuild,v 1.1 2005/03/08 18:28:42 mcummings Exp $

inherit perl-module

MY_PN="${PN}100"
MY_P=${MY_PN}-${PV}
S="${WORKDIR}/$MY_P"

DESCRIPTION="create a minimal mirror of CPAN containing the modules in the Phalanx 100"
HOMEPAGE="http://search.cpan.org/~smpeters/${MY_P}/"
SRC_URI="mirror://cpan/authors/id/S/SM/SMPETERS/${MY_P}.tar.gz"

LICENSE="Artistic"
#LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/CPAN-Mini"
