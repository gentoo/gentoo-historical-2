# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Term-ANSIScreen/Term-ANSIScreen-1.42.ebuild,v 1.14 2009/07/06 21:02:45 jer Exp $

IUSE=""

inherit perl-module

DESCRIPTION="Terminal control using ANSI escape sequences."
SRC_URI="mirror://cpan/authors/id/A/AU/AUTRIJUS/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/CPAN/data/ANSIScreen/ANSIScreen.html"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 hppa ia64 ~ppc sparc x86"

SRC_TEST="do"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
