# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-Coverage/Pod-Coverage-0.18.ebuild,v 1.1 2006/08/20 03:25:00 mcummings Exp $

inherit perl-module

DESCRIPTION="Checks if the documentation of a module is comprehensive"
HOMEPAGE="http://search.cpan.org/~rclamp/${P}/"
SRC_URI="mirror://cpan/authors/id/R/RC/RCLAMP/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=dev-perl/module-build-0.28
	dev-perl/ExtUtils-CBuilder
	>=virtual/perl-PodParser-1.13
	>=dev-perl/Devel-Symdump-2.01
	dev-lang/perl"
