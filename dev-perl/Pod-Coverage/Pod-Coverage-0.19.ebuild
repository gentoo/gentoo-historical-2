# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-Coverage/Pod-Coverage-0.19.ebuild,v 1.10 2008/11/18 15:26:14 tove Exp $

inherit perl-module

DESCRIPTION="Checks if the documentation of a module is comprehensive"
HOMEPAGE="http://search.cpan.org/~rclamp/"
SRC_URI="mirror://cpan/authors/id/R/RC/RCLAMP/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="test"
SRC_TEST="do"

DEPEND=">=virtual/perl-Module-Build-0.28
	virtual/perl-ExtUtils-CBuilder
	>=virtual/perl-PodParser-1.13
	>=dev-perl/Devel-Symdump-2.01
	dev-lang/perl
	test? ( dev-perl/Test-Pod )"
