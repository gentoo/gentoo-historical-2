# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Socket6/Socket6-0.20.ebuild,v 1.2 2008/07/17 20:16:32 armin76 Exp $

MODULE_AUTHOR=UMEMOTO
inherit perl-module

DESCRIPTION="IPv6 related part of the C socket.h defines and structure manipulators"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
