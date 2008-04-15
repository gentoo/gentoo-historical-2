# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql-docs/postgresql-docs-8.3.1.ebuild,v 1.1 2008/04/15 09:12:20 dev-zero Exp $

inherit versionator

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PostgreSQL documentation"
HOMEPAGE="http://www.postgresql.org/"
SRC_URI="mirror://postgresql/source/v${PV}/postgresql-${PV}.tar.bz2"
LICENSE="POSTGRESQL"
SLOT="$(get_version_component_range 1-2)"
IUSE=""

DEPEND=""

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
