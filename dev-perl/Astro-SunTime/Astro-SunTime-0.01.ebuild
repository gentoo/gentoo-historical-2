# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Astro-SunTime/Astro-SunTime-0.01.ebuild,v 1.3 2006/03/22 22:55:13 mcummings Exp $

inherit perl-module

DESCRIPTION="Provides a function interface to calculate sun rise/set times."
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/R/RO/ROBF/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

SRC_TEST="do"
DEPEND="dev-perl/Time-modules"
