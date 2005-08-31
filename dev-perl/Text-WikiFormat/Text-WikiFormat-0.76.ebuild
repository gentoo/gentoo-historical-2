# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-WikiFormat/Text-WikiFormat-0.76.ebuild,v 1.4 2005/08/31 17:53:33 dang Exp $

inherit perl-module

DESCRIPTION="Translate Wiki formatted text into other formats"
SRC_URI="mirror://cpan/authors/id/C/CH/CHROMATIC/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~chromatic/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-perl/URI
		dev-perl/Scalar-List-Utils
		dev-perl/module-build"
IUSE=""

SRC_TEST="do"
