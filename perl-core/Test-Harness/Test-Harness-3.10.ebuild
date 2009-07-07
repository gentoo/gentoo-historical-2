# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Test-Harness/Test-Harness-3.10.ebuild,v 1.5 2009/07/07 02:26:09 jer Exp $

MODULE_AUTHOR=ANDYA

inherit perl-module

DESCRIPTION="Runs perl standard test scripts with statistics"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl"

PREFER_BUILDPL=no
SRC_TEST="do"
mydoc="rfc*.txt"
