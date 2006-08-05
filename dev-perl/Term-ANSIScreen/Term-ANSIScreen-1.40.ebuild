# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Term-ANSIScreen/Term-ANSIScreen-1.40.ebuild,v 1.9 2006/08/05 23:11:36 mcummings Exp $

IUSE=""

inherit perl-module

DESCRIPTION="Terminal control using ANSI escape sequences."
SRC_URI="http://www.cpan.org/authors/id/A/AU/AUTRIJUS/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/CPAN/data/ANSIScreen/ANSIScreen.html"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
