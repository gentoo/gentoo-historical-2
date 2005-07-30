# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-LinkExtractor/HTML-LinkExtractor-0.13.ebuild,v 1.2 2005/07/30 12:35:21 pvdabeel Exp $

inherit perl-module

DESCRIPTION="A bare-bones HTML parser, similar to HTML::Parser, but with a couple important distinctions."
HOMEPAGE="http://www.cpan.org/modules/by-module/HTML/${P}.readme"
SRC_URI="mirror://cpan/authors/id/P/PO/PODMASTER/${P}.tar.gz"
IUSE=""
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ppc ~ppc64 ~sparc ~x86"

DEPEND="dev-perl/HTML-Parser"
