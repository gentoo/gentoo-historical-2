# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql-docs/postgresql-docs-8.2.22.ebuild,v 1.5 2011/10/01 17:25:30 armin76 Exp $

EAPI="4"

inherit versionator

KEYWORDS="alpha ~amd64 arm hppa ia64 ppc s390 sh sparc x86"

RESTRICT="test"

DESCRIPTION="PostgreSQL documentation"
HOMEPAGE="http://www.postgresql.org/"
SRC_URI="mirror://postgresql/source/v${PV}/postgresql-${PV}.tar.bz2"
LICENSE="POSTGRESQL"

S=${WORKDIR}/postgresql-${PV}
SLOT="$(get_version_component_range 1-2)"

IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	tar xjf "${DISTDIR}/${A}" -C "${WORKDIR}" "${A%.tar.bz2}/doc"
}

src_install() {
	cd "${S}/doc"

	dodir /usr/share/doc/${PF}/html
	tar -zxf "postgres.tar.gz" -C "${ED}/usr/share/doc/${PF}/html"
	fowners root:0 -R /usr/share/doc/${PF}/html

	docinto FAQ_html
	dodoc src/FAQ/*

	docinto sgml
	dodoc src/sgml/*.{sgml,dsl}
	docinto sgml/ref
	dodoc src/sgml/ref/*.sgml

	docinto TODO.detail
	dodoc TODO.detail/*

	dodir /etc/eselect/postgresql/slots/${SLOT}
	echo "postgres_ebuilds=\"\${postgres_ebuilds} ${PF}\"" > \
		"${ED}/etc/eselect/postgresql/slots/${SLOT}/docs"
}
