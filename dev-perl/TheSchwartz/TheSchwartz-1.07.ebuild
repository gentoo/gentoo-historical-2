# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/TheSchwartz/TheSchwartz-1.07.ebuild,v 1.3 2009/10/27 09:16:55 volkmar Exp $

MODULE_AUTHOR="BRADFITZ"

inherit perl-module

DESCRIPTION="Reliable job queue"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-perl/Data-ObjectDriver-0.06"
RDEPEND="${DEPEND}"

# testsuite broken.
SRC_TEST="never"
