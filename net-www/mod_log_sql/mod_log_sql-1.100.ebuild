# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_log_sql/mod_log_sql-1.100.ebuild,v 1.2 2005/02/05 09:57:50 trapni Exp $

inherit eutils apache-module

DESCRIPTION="An Apache module for logging to an SQL (MySQL) database"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_log_sql/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="ssl dbi"

DEPEND=">=dev-db/mysql-3.23.30
		dbi? ( >=dev-db/libdbi-0.7.0 )
		ssl? ( dev-libs/openssl !apache2? ( net-www/mod_ssl ) )"

APACHE1_MOD_CONF="${PV}/10_${PN}"
APACHE2_MOD_CONF="${PV}/10_${PN}"

APACHE1_MOD_DEFINE="LOG_SQL"
APACHE2_MOD_DEFINE="LOG_SQL"

APACHE1_EXECFILES="${PN}_mysql.so ${PN}_dbi.so ${PN}_ssl.so"
APACHE2_EXECFILES=".libs/${PN}_mysql.so .libs/${PN}_dbi.so .libs/${PN}_ssl.so"

DOCFILES="AUTHORS CHANGELOG INSTALL TODO docs/README docs/manual.html \
contrib/create_tables.sql contrib/make_combined_log.pl contrib/mysql_import_combined_log.pl"

need_apache

src_compile() {
	useq apache2 || myconf="--with-apxs=${APXS1}"
	useq apache2 && myconf="--with-apxs=${APXS2}"
	useq ssl && myconf="${myconf} --with-ssl-inc=/usr"
	useq ssl || myconf="${myconf} --without-ssl-inc"
	useq dbi && myconf="${myconf} --with-dbi=/usr"
	useq dbi || myconf="${myconf} --without-dbi"
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

pkg_postinst() {
	apache-module_pkg_postinst
	einfo "See /usr/share/doc/${PF}/create_tables.sql.gz "
	einfo "on how to create logging tables.\n"
}
