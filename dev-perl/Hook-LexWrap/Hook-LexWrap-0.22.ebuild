# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Hook-LexWrap/Hook-LexWrap-0.22.ebuild,v 1.7 2012/03/25 15:41:11 armin76 Exp $

MODULE_AUTHOR="CHORNY"
MODULE_A="${P}.zip"
inherit perl-module

DESCRIPTION="Lexically scoped subroutine wrappers"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	app-arch/unzip"

SRC_TEST="do"
