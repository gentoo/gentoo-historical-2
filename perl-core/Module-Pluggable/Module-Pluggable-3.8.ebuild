# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Module-Pluggable/Module-Pluggable-3.8.ebuild,v 1.1 2008/11/02 07:28:37 tove Exp $

MODULE_AUTHOR=SIMONW
inherit perl-module

DESCRIPTION="automatically give your module the ability to have plugins"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/perl-File-Spec
	dev-lang/perl"
