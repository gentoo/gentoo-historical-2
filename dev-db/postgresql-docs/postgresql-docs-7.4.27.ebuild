# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql-docs/postgresql-docs-7.4.27.ebuild,v 1.1 2010/01/07 00:49:56 patrick Exp $

inherit versionator

KEYWORDS="~amd64 ~hppa ~ppc ~x86"

DESCRIPTION="PostgreSQL documentation"
HOMEPAGE="http://www.postgresql.org/"
SRC_URI="mirror://postgresql/source/v${PV}/postgresql-${PV}.tar.bz2"
LICENSE="POSTGRESQL"
SLOT="$(get_version_component_range 1-2)"
IUSE=""

DEPEND=""
RDEPEND=""
RESTRICT="test"

S="${WORKDIR}/postgresql-${PV}"

src_compile() {
	:
}

src_install() {
	dodir /usr/share/doc/${PF}/html
	tar -zxf "${S}/doc/postgres.tar.gz" -C "${D}/usr/share/doc/${PF}/html"
	cd "${S}/doc"
	docinto FAQ_html
	dodoc src/FAQ/*
	docinto sgml
	dodoc src/sgml/*.{sgml,dsl}
	docinto sgml/ref
	dodoc src/sgml/ref/*.sgml
	docinto TODO.detail
	dodoc TODO.detail/*

	dodir /etc/eselect/postgresql/slots/${SLOT}
	{
		echo "postgres_ebuilds=\"\${postgres_ebuilds} ${PF}\""
	} >"${D}/etc/eselect/postgresql/slots/${SLOT}/docs"
}
