# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-FillInForm/HTML-FillInForm-1.05.ebuild,v 1.3 2006/08/05 04:19:54 mcummings Exp $

inherit perl-module

DESCRIPTION="Populates HTML Forms with data."
HOMEPAGE="http://search.cpan.org/~tjmather/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TJ/TJMATHER/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
