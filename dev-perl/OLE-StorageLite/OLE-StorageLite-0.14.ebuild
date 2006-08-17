# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/OLE-StorageLite/OLE-StorageLite-0.14.ebuild,v 1.6 2006/08/17 21:07:18 mcummings Exp $

inherit perl-module

MY_P=${P/StorageLite/Storage_Lite}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simple Class for OLE document interface."
HOMEPAGE="http://search.cpan.org/~jmcnamara/${MY_P}/"
SRC_URI="mirror://cpan/authors/id/J/JM/JMCNAMARA/${MY_P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ia64 sparc x86"
IUSE=""

SRC_TEST="do"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
