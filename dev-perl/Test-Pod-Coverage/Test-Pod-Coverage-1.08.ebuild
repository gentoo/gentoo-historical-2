# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Pod-Coverage/Test-Pod-Coverage-1.08.ebuild,v 1.20 2009/01/26 11:52:03 tove Exp $

MODULE_AUTHOR=PETDANCE
inherit perl-module

DESCRIPTION="Check for pod coverage in your distribution"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/perl-Test-Simple-0.62
	dev-perl/Pod-Coverage
	dev-lang/perl"
