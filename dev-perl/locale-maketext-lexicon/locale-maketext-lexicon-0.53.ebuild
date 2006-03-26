# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/locale-maketext-lexicon/locale-maketext-lexicon-0.53.ebuild,v 1.2 2006/03/26 16:00:41 mcummings Exp $

inherit perl-module

MY_P=Locale-Maketext-Lexicon-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Use other catalog formats in Maketext"
HOMEPAGE="http://www.cpan.org/authors/id/A/AU/AUTRIJUS/"
SRC_URI="mirror://cpan/authors/id/A/AU/AUTRIJUS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc sparc x86"
IUSE=""

DEPEND="virtual/perl-locale-maketext"

SRC_TEST="do"
