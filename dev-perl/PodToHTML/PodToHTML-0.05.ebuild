# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PodToHTML/PodToHTML-0.05.ebuild,v 1.3 2006/06/12 16:11:48 mcummings Exp $

inherit perl-module

DESCRIPTION="convert POD documentation to HTML"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/N/NI/NI-S/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/HTML-Tree
		dev-perl/HTML-Parser
		dev-perl/HTML-Format"
