# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Proc-ProcessTable/Proc-ProcessTable-0.39.ebuild,v 1.5 2004/12/23 16:36:09 nigoro Exp $

inherit perl-module

DESCRIPTION="Unix process table information"
SRC_URI="http://www.cpan.org/modules/by-authors/id/D/DU/DURIST/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/D/DU/DURIST/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~mips ~ppc ~sparc ~ppc64"
IUSE=""

SRC_TEST="do"
