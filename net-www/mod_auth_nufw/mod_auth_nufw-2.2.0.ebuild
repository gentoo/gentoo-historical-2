# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_auth_nufw/mod_auth_nufw-2.2.0.ebuild,v 1.1 2006/12/31 16:15:43 cedk Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit eutils apache-module autotools

DESCRIPTION="mod_auth_nufw A NuFW authentication module for apache"
HOMEPAGE="http://www.inl.fr/mod-auth-nufw.html"
SRC_URI="http://software.inl.fr/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="apache2 mysql postgres ldap"

DEPEND="dev-libs/apr
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	ldap? ( net-nds/openldap )"
RDEPEND=""

APACHE2_MOD_FILE="mod_auth_nufw.so"

APACHE1_MOD_CONF="50_${PN}"
APACHE1_MOD_DEFINE="AUTH_NUFW"

APACHE2_MOD_CONF="50_${PN}"
APACHE2_MOD_DEFINE="AUTH_NUFW"

DOCFILES="doc/mod_auth_nufw.html"

need_apache

pkg_setup() {
	local cnt=0
	use mysql && cnt="$((${cnt} + 1))"
	use postgres && cnt="$((${cnt} + 1))"
	if [[ "${cnt}" -ne 1 ]] ; then
		eerror "You have set ${P} to use multiple sql engine."
		eerror "I don't know which to use!"
		eerror "You can use /etc/portage/package.use to	set per-package USE flags"
		eerror "Set it so only one sql engine type mysql, postgres"
		die "Please set only one sql engine type"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-configure_in.patch"
}

src_compile() {
	cd "${S}"

	local apx
	if [ ${APACHE_VERSION} -eq '1' ]; then
		apx=${APXS1}
	else
		apx=${APXS2}
	fi

	APR_INCLUDE="-I`apr-config --includedir`"

	eautoreconf
	econf \
		$(use_with apache2 apache20) \
		$(use_with mysql) \
		$(use_with ldap ldap-uids) \
		--with-apxs=${apx} \
		CPPFLAGS="${APR_INCLUDE} ${CPPFLAGS}" \
		|| die "econf failed"
	emake || die "emake failed"
}
