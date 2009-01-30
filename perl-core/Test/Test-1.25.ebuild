# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Test/Test-1.25.ebuild,v 1.8 2009/01/30 13:22:12 tove Exp $

MODULE_AUTHOR=SBURKE
inherit perl-module

DESCRIPTION="Utilities for writing test scripts"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE=""

DEPEND="dev-lang/perl"

SRC_TEST="do"
