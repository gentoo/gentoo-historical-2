# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IPC-ShareLite/IPC-ShareLite-0.09.ebuild,v 1.8 2004/12/24 13:46:02 nigoro Exp $

inherit perl-module

DESCRIPTION="IPC::ShareLite module for perl"
SRC_URI="http://www.cpan.org/authors/id/M/MA/MAURICE/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/M/MA/MAURICE/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ~ppc sparc alpha ~ppc64"
IUSE=""

DEPEND="${DEPEND}"

export OPTIMIZE="$CFLAGS"

# closing stdin causes IPC-ShareLites build system use a
# non-interactive mode <mkennedy@gentoo.org>

exec <&-
