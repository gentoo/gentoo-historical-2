# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-DBI/Apache-DBI-0.92.ebuild,v 1.6 2004/06/25 21:32:54 kugelfang Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Apache::DBI module for perl"
SRC_URI="http://cpan.org/modules/by-module/Apache/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/Apache/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ~ppc sparc alpha"

DEPEND="${DEPEND}
	dev-perl/Test-Simple
	>=dev-perl/DBI-1.30"

export OPTIMIZE="$CFLAGS"
