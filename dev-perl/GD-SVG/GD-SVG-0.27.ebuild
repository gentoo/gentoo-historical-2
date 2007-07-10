# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GD-SVG/GD-SVG-0.27.ebuild,v 1.9 2007/07/10 23:33:29 mr_bones_ Exp $

inherit perl-module

DEPEND="dev-perl/GD
	dev-perl/SVG
	dev-lang/perl"

DESCRIPTION="Seamlessly enable SVG output from scripts written using GD"
SRC_URI="mirror://cpan/authors/id/T/TW/TWH/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~twh/${P}/"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86"
