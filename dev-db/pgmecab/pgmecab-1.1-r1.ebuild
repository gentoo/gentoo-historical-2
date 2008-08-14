# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgmecab/pgmecab-1.1-r1.ebuild,v 1.1 2008/08/14 23:54:50 matsuu Exp $

inherit eutils

DESCRIPTION="PostgreSQL function to Wakachigaki for Japanese words"
HOMEPAGE="http://www.emaki.minidns.net/Programming/postgres/index.html"
SRC_URI="http://www.emaki.minidns.net/Programming/postgres/${P}.tar.bz2"

DEPEND="app-text/mecab
	>=virtual/postgresql-server-7.4"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack () {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	emake USE_PGXS=1 || die
}

src_install() {
	emake DESTDIR="${D}" USE_PGXS=1 install || die
}
