# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-TokeParser-Simple/HTML-TokeParser-Simple-2.2.ebuild,v 1.3 2004/06/25 00:37:44 agriffis Exp $

inherit perl-module

DESCRIPTION="A bare-bones HTML parser, similar to HTML::Parser, but with a couple important distinctions."
HOMEPAGE="http://www.cpan.org/modules/by-module/HTML/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/HTML/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

DEPEND=">=dev-perl/HTML-Parser-3.25"
