# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Unaccent/Text-Unaccent-1.08.ebuild,v 1.5 2006/01/15 17:49:30 mcummings Exp $

inherit perl-module

DESCRIPTION="Removes accents from a string"
HOMEPAGE="http://search.cpan.org/~ldachary/${P}/"
SRC_URI="mirror://cpan/authors/id/L/LD/LDACHARY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~x86 ~sparc ~alpha ~ppc ~amd64"
KEYWORDS="~hppa ~ppc sparc x86"
IUSE=""

SRC_TEST="do"
