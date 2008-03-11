# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pygresql/pygresql-3.5.ebuild,v 1.10 2008/03/11 05:01:17 ricmm Exp $

inherit eutils distutils

KEYWORDS="alpha amd64 hppa ~ia64 ~mips ~ppc sparc x86"

MY_P="PyGreSQL-${PV}"

DESCRIPTION="A Python interface for the PostgreSQL database."
SRC_URI="ftp://ftp.pygresql.org/pub/distrib/${MY_P}.tgz"
HOMEPAGE="http://www.pygresql.org/"
LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND="dev-db/libpq"
RDEPEND="${DEPEND}
		dev-python/egenix-mx-base"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-gentoo.patch"
}
