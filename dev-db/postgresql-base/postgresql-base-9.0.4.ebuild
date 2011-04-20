# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql-base/postgresql-base-9.0.4.ebuild,v 1.1 2011/04/20 03:02:34 titanofold Exp $

EAPI="4"

WANT_AUTOMAKE="none"

inherit autotools eutils multilib prefix versionator

SLOT="$(get_version_component_range 1-2)"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"

DESCRIPTION="PostgreSQL libraries and clients"
HOMEPAGE="http://www.postgresql.org/"
SRC_URI="mirror://postgresql/source/v${PV}/postgresql-${PV}.tar.bz2
		 http://dev.gentoo.org/~titanofold/postgresql-patches-${SLOT}.tbz2"
LICENSE="POSTGRESQL"

S="${WORKDIR}/postgresql-${PV}"

# No tests to be done for clients and libraries
RESTRICT="test"

LINGUAS="af cs de es fa fr hr hu it ko nb pl pt_BR ro ru sk sl sv tr zh_CN zh_TW"
IUSE="doc kerberos ldap nls pam pg_legacytimestamp readline ssl threads zlib"

for lingua in ${LINGUAS} ; do
	IUSE+=" linguas_${lingua}"
done

wanted_languages() {
	local enable_langs

	for lingua in ${LINGUAS} ; do
		use linguas_${lingua} && enable_langs+="${lingua} "
	done

	echo -n ${enable_langs}
}

RDEPEND=">=app-admin/eselect-postgresql-1.0.7
		 virtual/libintl
		 !!dev-db/libpq
		 !!dev-db/postgresql
		 !!dev-db/postgresql-client
		 !!dev-db/postgresql-libs
		 kerberos? ( virtual/krb5 )
		 ldap? ( net-nds/openldap )
		 pam? ( virtual/pam )
		 readline? ( sys-libs/readline )
		 ssl? ( >=dev-libs/openssl-0.9.6-r1 )
		 zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
		sys-devel/bison
		sys-devel/flex
		nls? ( sys-devel/gettext )"

PDEPEND="doc? ( ~dev-db/postgresql-docs-${PV} )"

src_prepare() {
	epatch "${WORKDIR}/autoconf.patch" \
		"${WORKDIR}/base.patch"

	eprefixify src/include/pg_config_manual.h

	# to avoid collision - it only should be installed by server
	rm "${S}/src/backend/nls.mk"

	# because psql/help.c includes the file
	ln -s "${S}/src/include/libpq/pqsignal.h" "${S}/src/bin/psql/" || die

	eautoconf
}

src_configure() {
	export LDFLAGS_SL="${LDFLAGS}"
	export LDFLAGS_EX="${LDFLAGS}"
	econf --prefix=${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT} \
		--datadir=${EROOT%/}/usr/share/postgresql-${SLOT} \
		--docdir=${EROOT%/}/usr/share/doc/postgresql-${SLOT} \
		--includedir=${EROOT%/}/usr/include/postgresql-${SLOT} \
		--mandir=${EROOT%/}/usr/share/postgresql-${SLOT}/man \
		--sysconfdir=${EROOT%/}/etc/postgresql-${SLOT} \
		--enable-depend \
		--without-tcl \
		--without-perl \
		--without-python \
		$(use_with kerberos krb5) \
		$(use_with kerberos gssapi) \
		$(use_with ldap) \
		"$(use_enable nls nls "$(wanted_languages)")" \
		$(use_with pam) \
		$(use_enable !pg_legacytimestamp integer-datetimes) \
		$(use_with readline) \
		$(use_with ssl openssl) \
		$(use_enable threads thread-safety) \
		$(use_with zlib)
}

src_compile() {
	emake

	cd "${S}/contrib"
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	insinto /usr/include/postgresql-${SLOT}/postmaster
	doins "${S}"/src/include/postmaster/*.h

	dodir /usr/share/postgresql-${SLOT}/man/man1/
	cp "${S}"/doc/src/sgml/man1/* "${ED}"/usr/share/postgresql-${SLOT}/man/man1/ || die

	rm "${ED}/usr/share/postgresql-${SLOT}/man/man1"/{initdb,pg_controldata,pg_ctl,pg_resetxlog,pg_restore,postgres,postmaster}.1
	dodoc README HISTORY doc/{README.*,TODO,bug.template}

	cd "${S}/contrib"
	emake DESTDIR="${D}" install
	cd "${S}"

	dodir /etc/eselect/postgresql/slots/${SLOT}

	echo "postgres_ebuilds=\"\${postgres_ebuilds} ${PF}\"" \
		> "${ED}/etc/eselect/postgresql/slots/${SLOT}/base"

	keepdir /etc/postgresql-${SLOT}
}

pkg_postinst() {
	postgresql-config update

	elog "If you need a global psqlrc-file, you can place it in:"
	elog "    ${EROOT%/}/etc/postgresql-${SLOT}/"
}

pkg_postrm() {
	postgresql-config update
}
