# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IPC-ShareLite/IPC-ShareLite-0.09.ebuild,v 1.17 2006/08/02 17:51:41 gustavoz Exp $

inherit perl-module

DESCRIPTION="IPC::ShareLite module for perl"
SRC_URI="mirror://cpan/authors/id/M/MA/MAURICE/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/M/MA/MAURICE/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

export OPTIMIZE="$CFLAGS"

src_compile() {
	echo "" | perl-module_src_compile
}
