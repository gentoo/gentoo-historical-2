# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/capitalization/capitalization-0.03.ebuild,v 1.2 2006/01/13 18:11:56 mcummings Exp $

inherit perl-module

DESCRIPTION="no capitalization on method names"
HOMEPAGE="http://search.cpan.org/~miyagawa/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MI/MIYAGAWA/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Devel-Symdump"
