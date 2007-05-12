# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_log_sql/mod_log_sql-1.100.ebuild,v 1.12 2007/05/12 12:08:27 chtekk Exp $

inherit apache-module

KEYWORDS="~amd64 ppc x86"

DESCRIPTION="An Apache module for logging to an SQL (MySQL) database."
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_log_sql/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"
LICENSE="as-is"
SLOT="0"
IUSE="dbi ssl"

DEPEND="virtual/mysql
		dbi? ( dev-db/libdbi )
		ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="42_${PN}"
APACHE2_MOD_DEFINE="LOG_SQL"

APACHE2_EXECFILES=".libs/${PN}_mysql.so .libs/${PN}_dbi.so .libs/${PN}_ssl.so"

DOCFILES="AUTHORS CHANGELOG docs/README docs/manual.html \
contrib/create_tables.sql contrib/make_combined_log.pl contrib/mysql_import_combined_log.pl"

need_apache

src_compile() {
	local myconf="--with-apxs=${APXS2}"
	use ssl && myconf="${myconf} --with-ssl-inc=/usr"
	use ssl || myconf="${myconf} --without-ssl-inc"
	use dbi && myconf="${myconf} --with-dbi=/usr"
	use dbi || myconf="${myconf} --without-dbi"
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

pkg_postinst() {
	apache-module_pkg_postinst
	einfo "See /usr/share/doc/${PF}/create_tables.sql.gz"
	einfo "on how to create logging tables."
}
