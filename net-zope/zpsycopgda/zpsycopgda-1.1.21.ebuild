# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zpsycopgda/zpsycopgda-1.1.21.ebuild,v 1.1 2005/12/11 19:42:17 radek Exp $

inherit zproduct
S="${WORKDIR}/psycopg-${PV}/"

DESCRIPTION="PostgreSQL database adapter for Zope."
SRC_URI="http://initd.org/pub/software/psycopg/psycopg-${PV}.tar.gz"
HOMEPAGE="http://www.initd.org/software/psycopg.py"
RDEPEND=">=dev-python/psycopg-${PV}
	${RDEPEND}"
KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"

ZPROD_LIST="ZPsycopgDA"
IUSE=""

src_compile()
{
	rm -f * >& /dev/null
	rm -fR debian/ doc/ tests/
}
