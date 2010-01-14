# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tree-DAG_Node/Tree-DAG_Node-1.06.ebuild,v 1.2 2010/01/14 16:05:43 grobian Exp $

MODULE_AUTHOR=COGENT
inherit perl-module

DESCRIPTION="(super)class for representing nodes in a tree"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
