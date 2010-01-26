# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql-docs/postgresql-docs-8.5_alpha3.ebuild,v 1.1 2010/01/26 19:26:05 patrick Exp $

EAPI=2

inherit versionator autotools

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"

# Nothing to test here per 232157
RESTRICT="test"

DESCRIPTION="PostgreSQL documentation"
HOMEPAGE="http://www.postgresql.org/"

MY_PV=${PV/_/}
SRC_URI="mirror://postgresql/source/${MY_PV}/postgresql-${MY_PV}.tar.bz2"
S=${WORKDIR}/postgresql-${MY_PV}


LICENSE="POSTGRESQL"
SLOT="$(get_version_component_range 1-2)"
IUSE=""

DEPEND="app-text/openjade
	app-text/docbook-sgml-dtd:4.2
	app-text/docbook-dsssl-stylesheets"

src_prepare() {
	epatch "${FILESDIR}/postgresql-${SLOT}-common.patch"
	eautoconf || die "Failed to eautoconf"
}

src_compile() {
	cd doc
	emake html || die
}

src_install() {
	dodir /usr/share/doc/${PF}/html
	#tar -zxf "${S}/doc/postgres.tar.gz" -C "${D}/usr/share/doc/${PF}/html"
	cd "${S}/doc"
	docinto FAQ_html
	#dodoc src/FAQ/* # no longer there?
	docinto sgml
	dodoc src/sgml/*.{sgml,dsl}
	docinto sgml/ref
	dodoc src/sgml/ref/*.sgml
	docinto html
	dodoc src/sgml/html/*.html
	docinto
	dodoc TODO

	dodir /etc/eselect/postgresql/slots/${SLOT}
	{
		echo "postgres_ebuilds=\"\${postgres_ebuilds} ${PF}\""
	} >"${D}/etc/eselect/postgresql/slots/${SLOT}/docs"
}
