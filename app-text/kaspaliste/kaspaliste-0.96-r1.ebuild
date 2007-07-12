# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/kaspaliste/kaspaliste-0.96-r1.ebuild,v 1.6 2007/07/12 04:37:47 mr_bones_ Exp $

ARTS_REQUIRED="yes"

inherit kde eutils

DESCRIPTION="A literature database"
HOMEPAGE="http://kaspaliste.sourceforge.net"
SRC_URI="mirror://sourceforge/kaspaliste/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-db/postgresql-7.3"
need-kde 3

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/gcc34.patch
}

pkg_postinst() {
	elog "You have to create a database named kaspaliste: %createdb kaspaliste."
	elog "And then import the file kaspaliste/data/create.tables.sql from the kaspaliste directory:"
	elog "%psql kaspaliste -f create.tables.sql"
}
