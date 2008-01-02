# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/cache-mmap/cache-mmap-0.09.ebuild,v 1.8 2008/01/02 10:58:32 armin76 Exp $

inherit perl-module

MY_P=Cache-Mmap-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Shared data cache using memory mapped files"
SRC_URI="mirror://cpan/authors/id/P/PM/PMH/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/PMH/${MY_P}"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND="virtual/perl-Test-Simple
	virtual/perl-Storable
	dev-lang/perl"
