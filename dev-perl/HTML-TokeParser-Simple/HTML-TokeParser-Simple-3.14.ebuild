# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-TokeParser-Simple/HTML-TokeParser-Simple-3.14.ebuild,v 1.3 2006/01/15 11:39:06 hansmi Exp $

inherit perl-module

DESCRIPTION="A bare-bones HTML parser, similar to HTML::Parser, but with a couple important distinctions."
HOMEPAGE="http://www.cpan.org/modules/by-module/HTML/${P}.readme"
SRC_URI="mirror://cpan/authors/id/O/OV/OVID/${P}.tar.gz"
IUSE=""
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"

SRC_TEST="do"

DEPEND=">=dev-perl/HTML-Parser-3.25
		perl-core/Test-Simple
		dev-perl/Sub-Override"
