# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/UNIVERSAL-require/UNIVERSAL-require-0.11.ebuild,v 1.3 2007/12/06 16:41:48 armin76 Exp $

inherit perl-module

DESCRIPTION="UNIVERSAL::require - require() modules from a variable"
HOMEPAGE="http://search.cpan.org/~mschwern/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHWERN/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-lang/perl"
