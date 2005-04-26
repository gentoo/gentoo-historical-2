# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-FromText/HTML-FromText-2.05.ebuild,v 1.6 2005/04/26 19:55:17 kloeri Exp $

inherit perl-module

DESCRIPTION="Convert plain text to HTML."
HOMEPAGE="http://search.cpan.org/~cwest/${P}/"
SRC_URI="mirror://cpan/authors/id/C/CW/CWEST/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~amd64"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/HTML-Parser
	dev-perl/Test-Simple
	dev-perl/Exporter-Lite
	>=dev-perl/Scalar-List-Utils-1.14
	dev-perl/Email-Find"
