# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/tinyerp-server/tinyerp-server-4.0.2.ebuild,v 1.2 2007/02/01 19:51:56 cedk Exp $

inherit eutils distutils

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://tinyerp.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-db/postgresql-7.4
	dev-python/pypgsql
	dev-python/reportlab
	dev-python/pyparsing
	media-gfx/pydot
	=dev-python/psycopg-1*
	dev-libs/libxml2
	dev-libs/libxslt"
RDEPEND=${DEPEND}

TINYERP_USER=terp
TINYERP_GROUP=terp

pkg_setup() {
	if ! built_with_use dev-libs/libxslt python ; then
		eerror "dev-libs/libxslt must be built with python"
		die "${PN} requires dev-libs/libxslt with USE=python"
	fi
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}"/tinyerp-init.d tinyerp
	newconfd "${FILESDIR}"/tinyerp-conf.d tinyerp

	keepdir /var/run/tinyerp
	keepdir /var/log/tinyerp
}

pkg_preinst() {
	enewgroup ${TINYERP_GROUP}
	enewuser ${TINYERP_USER} -1 -1 -1 ${TINYERP_GROUP}

	fowners ${TINYERP_USER}:${TINYERP_GROUP} /var/run/tinyerp
	fowners ${TINYERP_USER}:${TINYERP_GROUP} /var/log/tinyerp
}

pkg_postinst() {
	elog "In order to setup the initial database, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

pquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! pquery "SELECT usename FROM pg_user WHERE usename = '${TINYERP_USER}'" | grep -q ${TINYERP_USER}; then
		ebegin "Creating database user ${TINYERP_USER}"
		createuser --quiet --username=postgres --createdb ${TINYERP_USER}
		eend $? || die "Failed to create database user"
	fi
}
