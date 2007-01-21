# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Inline-Java/Inline-Java-0.52.ebuild,v 1.1 2007/01/21 19:15:20 mcummings Exp $

inherit perl-module

DESCRIPTION="Easy implimentaiton of Java extensions"
HOMEPAGE="http://search.cpan.org/~patl/"
SRC_URI="mirror://cpan/authors/id/P/PA/PATL/${P}.tar.gz"

LICENSE="Artistic"
#LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/Inline-0.44
	>=virtual/perl-Test-1.13
		>=virtual/jdk-1.4
	dev-lang/perl"

myconf="J2SDK=$JAVA_HOME"
mymake="java all"

