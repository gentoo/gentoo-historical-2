# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Template-GD/Template-GD-2.66.ebuild,v 1.2 2006/08/20 17:16:48 tester Exp $

inherit perl-module

DESCRIPTION="GD plugin(s) for the Template Toolkit"
SRC_URI="mirror://cpan/modules/by-module/Template/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/dist/${P}/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl
	dev-perl/GD
	dev-perl/GDTextUtil
	dev-perl/GDGraph
	dev-perl/GD-Graph3d
	>=dev-perl/Template-Toolkit-2.15-r1"
RDEPEND="${DEPEND}"
