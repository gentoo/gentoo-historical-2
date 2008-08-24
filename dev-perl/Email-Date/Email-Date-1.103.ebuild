# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Date/Email-Date-1.103.ebuild,v 1.2 2008/08/24 13:01:21 bluebird Exp $

MODULE_AUTHOR=RJBS
inherit perl-module

DESCRIPTION="Find and Format Date Headers"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~sparc ~x86"
#KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-perl/TimeDate-1.16
	>=dev-perl/Email-Abstract-2.13.1
	dev-perl/Email-Date-Format
	virtual/perl-Time-Local
	dev-perl/Time-Piece
	dev-lang/perl"

SRC_TEST="do"
