# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/sphinx/sphinx-0.9.8_rc2.ebuild,v 1.1 2008/04/04 12:04:57 caleb Exp $

inherit eutils autotools

MY_P=${P/_/-}

DESCRIPTION="Full-text search engine with support for MySQL and PostgreSQL"
HOMEPAGE="http://www.sphinxsearch.com/"
SRC_URI="http://sphinxsearch.com/downloads/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mysql postgres debug"

DEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/libpq )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with debug) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc doc/* example.sql
	dodir /etc/sphinx
	insinto /etc/sphinx
	doins sphinx.conf.dist

	dodir /var/lib/sphinx
	dodir /var/log/sphinx
	dodir /var/run/sphinx
}
