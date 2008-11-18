# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sub-Uplevel/Sub-Uplevel-0.19.01.ebuild,v 1.4 2008/11/18 15:31:43 tove Exp $

inherit perl-module versionator

MY_P="${PN}-$(delete_version_separator 2)"
S=${WORKDIR}/${MY_P}

DESCRIPTION="apparently run a function in a higher stack frame"
HOMEPAGE="http://search.cpan.org/~mschwern/${MY_P}/"
SRC_URI="mirror://cpan/authors/id/D/DA/DAGOLDEN/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/perl-Module-Build
		dev-lang/perl"
RDEPEND="dev-lang/perl"
