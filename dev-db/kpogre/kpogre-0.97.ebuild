# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/kpogre/kpogre-0.97.ebuild,v 1.4 2004/06/24 21:55:14 agriffis Exp $

inherit kde-base eutils
need-kde 3

DESCRIPTION="PostgreSQL grafical frontend for KDE"
HOMEPAGE="http://kpogre.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

DEPEND="dev-db/postgresql
	>=dev-libs/libpqxx-2.2.1"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

