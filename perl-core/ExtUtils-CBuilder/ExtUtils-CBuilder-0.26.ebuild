# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/ExtUtils-CBuilder/ExtUtils-CBuilder-0.26.ebuild,v 1.1 2009/06/30 06:25:37 tove Exp $

EAPI=2

MODULE_AUTHOR=DAGOLDEN
inherit perl-module

DESCRIPTION="Compile and link C code for Perl modules"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST="do"
