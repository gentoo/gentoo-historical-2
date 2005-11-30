# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-FromText/HTML-FromText-2.05.ebuild,v 1.1 2004/06/06 03:35:09 mcummings Exp $

inherit perl-module

DESCRIPTION="Convert plain text to HTML."
HOMEPAGE="http://search.cpan.org/~cwest/${P}/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/C/CW/CWEST/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"

SRC_TEST="do"

DEPEND="dev-perl/HTML-Parser
	dev-perl/Test-Simple
	dev-perl/Exporter-Lite
	>=dev-perl/Scalar-List-Utils-1.14
	dev-perl/Email-Find"

