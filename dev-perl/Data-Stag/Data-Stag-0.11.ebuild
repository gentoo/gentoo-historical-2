# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Stag/Data-Stag-0.11.ebuild,v 1.1 2009/03/13 00:05:57 weaver Exp $

inherit perl-module

DESCRIPTION="Structured Tags datastructures"
HOMEPAGE="http://stag.sourceforge.net/"
SRC_URI="mirror://cpan/authors/id/C/CM/CMUNGALL/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
SRC_TEST="do"

DEPEND="dev-lang/perl
	dev-perl/IO-String"
