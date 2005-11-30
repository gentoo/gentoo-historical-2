# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Curses-UI/Curses-UI-0.95.ebuild,v 1.1 2005/04/25 11:32:22 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl UI framework based on the curses library."
HOMEPAGE="http://search.cpan.org/~marcus/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MA/MARCUS/${P}.tar.gz"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Curses
	dev-perl/Test-Pod
	dev-perl/TermReadKey"
