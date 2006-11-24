# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-CSV-Simple/Text-CSV-Simple-1.00.ebuild,v 1.4 2006/11/24 18:27:59 mcummings Exp $

inherit perl-module

DESCRIPTION="Text::CSV::Simple - Simpler parsing of CSV files"
SRC_URI="mirror://cpan/authors/id/T/TM/TMTM/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~tmtm/${P}/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
IUSE=""
SRC_TEST="do"
DEPEND="dev-perl/Text-CSV_XS
		dev-perl/Class-Trigger
		dev-perl/File-Slurp
		dev-lang/perl"
RDEPEND="${DEPEND}"
