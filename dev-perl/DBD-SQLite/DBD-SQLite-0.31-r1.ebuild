# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBD-SQLite/DBD-SQLite-0.31-r1.ebuild,v 1.4 2009/11/19 11:26:13 tove Exp $

MODULE_AUTHOR=MSERGEANT
inherit perl-module

DESCRIPTION="Self Contained RDBMS in a DBI Driver"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 sparc ~ppc"
IUSE=""
SRC_TEST="do"

DEPEND="dev-perl/DBI
	dev-lang/perl"
