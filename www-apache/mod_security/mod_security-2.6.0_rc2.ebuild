# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_security/mod_security-2.6.0_rc2.ebuild,v 1.1 2011/05/02 17:12:21 flameeyes Exp $

EAPI=4

inherit apache-module autotools

MY_P=modsecurity-apache_${PV/_rc/-rc}

DESCRIPTION="Web application firewall and Intrusion Detection System for Apache."
HOMEPAGE="http://www.modsecurity.org/"
SRC_URI="http://www.modsecurity.org/download/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="geoip curl"

DEPEND=">=dev-libs/libxml2-2.7.8
	dev-libs/libpcre
	>=dev-lang/lua-5.1
	curl? ( >=net-misc/curl-7.15.1 )
	www-servers/apache[apache2_modules_unique_id]"
RDEPEND="${DEPEND}
	geoip? ( dev-libs/geoip )"
PDEPEND="www-apache/modsecurity-crs"

S="${WORKDIR}/${MY_P}"

APACHE2_MOD_FILE="apache2/.libs/${PN}2.so"
APACHE2_MOD_DEFINE="SECURITY"

# Tests require symbols only defined within the Apache binary.
RESTRICT=test

need_apache2

src_prepare() {
	cp "${FILESDIR}"/modsecurity.conf "${T}"/79_modsecurity.conf || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-shared --disable-static \
		--with-apxs="${APXS}" \
		$(use_enable curl mlogc) \
		|| die "econf failed"
}

src_compile() {
	if ! use geoip; then
		sed -i -e '/SecGeoLookupDb/s:^:#:' \
			"${T}"/79_modsecurity.conf || die
	fi

	emake || die
}

src_test() {
	emake check || die
}

src_install() {
	apache-module_src_install

	# install manually rather than by using the APACHE2_MOD_CONF
	# variable since we have to edit it to set things up properly.
	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${T}"/79_modsecurity.conf

	dodoc CHANGES

	keepdir /var/cache/modsecurity
	fowners apache:apache /var/cache/modsecurity
	fperms 0770 /var/cache/modsecurity
}

pkg_postinst() {
	if [[ -f "${ROOT}"/etc/apache/modules.d/99_mod_security.conf ]]; then
		ewarn "You still have the configuration file 99_mod_security.conf."
		ewarn "Please make sure to remove that and keep only 79_modsecurity.conf."
		ewarn ""
	fi
	elog "The base configuration file has been renamed 79_modsecurity.conf"
	elog "so that you can put your own configuration as 90_modsecurity_local.conf or"
	elog "equivalent."
	elog ""
	elog "That would be the correct place for site-global security rules."
	elog "Note: 80_modsecurity_crs.conf is used by www-apache/modsecurity-crs"
}
