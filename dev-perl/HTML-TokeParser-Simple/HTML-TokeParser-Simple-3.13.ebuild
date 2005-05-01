# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-TokeParser-Simple/HTML-TokeParser-Simple-3.13.ebuild,v 1.4 2005/05/01 18:01:40 slarti Exp $

inherit perl-module

DESCRIPTION="A bare-bones HTML parser, similar to HTML::Parser, but with a couple important distinctions."
HOMEPAGE="http://www.cpan.org/modules/by-module/HTML/${P}.readme"
SRC_URI="mirror://cpan/authors/id/O/OV/OVID/${P}.tar.gz"
IUSE=""
LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~amd64"

SRC_TEST="do"

DEPEND=">=dev-perl/HTML-Parser-3.25
		dev-perl/Test-Simple
		dev-perl/Sub-Override"
