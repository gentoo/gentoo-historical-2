# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-Coverage/Pod-Coverage-0.20.ebuild,v 1.2 2010/01/10 19:41:48 grobian Exp $

MODULE_AUTHOR=RCLAMP
inherit perl-module

DESCRIPTION="Checks if the documentation of a module is comprehensive"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND=">=virtual/perl-PodParser-1.13
	>=dev-perl/Devel-Symdump-2.01
	dev-lang/perl"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
