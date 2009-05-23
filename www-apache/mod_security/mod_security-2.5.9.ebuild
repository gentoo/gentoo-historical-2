# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_security/mod_security-2.5.9.ebuild,v 1.2 2009/05/23 10:23:58 maekke Exp $

inherit apache-module autotools

MY_P=${P/mod_security-/modsecurity-apache_}
MY_P=${MY_P/_rc/-rc}

DESCRIPTION="Web application firewall and Intrusion Detection System for Apache."
HOMEPAGE="http://www.modsecurity.org/"
SRC_URI="http://www.modsecurity.org/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~sparc x86"
IUSE="lua"

DEPEND="dev-libs/libxml2
	lua? ( >=dev-lang/lua-5.1 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

APACHE2_MOD_FILE="apache2/.libs/${PN}2.so"
APACHE2_MOD_CONF="2.1.2/99_mod_security"
APACHE2_MOD_DEFINE="SECURITY"

need_apache2

src_unpack() {
	unpack ${A}

	cd "${S}"/apache2

	epatch "${FILESDIR}"/${P}-broken-autotools.patch

	eautoreconf
}

src_compile() {
	cd apache2

	econf --with-apxs="${APXS}" \
		--without-curl \
		$(use_with lua) \
		|| die "econf failed"

	APXS_FLAGS=
	for flag in ${CFLAGS}; do
		APXS_FLAGS="${APXS_FLAGS} -Wc,${flag}"
	done

	# Yes we need to prefix it _twice_
	for flag in ${LDFLAGS}; do
		APXS_FLAGS="${APXS_FLAGS} -Wl,${flag}"
	done

	emake \
		APXS_CFLAGS="${CFLAGS}" \
		APXS_LDFLAGS="${LDFLAGS}" \
		APXS_EXTRA_CFLAGS="${APXS_FLAGS}" \
		|| die "emake failed"
}

src_test() {
	cd apache2
	make test || die
}

src_install() {
	apache-module_src_install

	# install rules updater
	newbin tools/rules-updater.pl modsec-rules-updater || die

	# install documentation
	dodoc CHANGES || die
	newdoc rules/CHANGELOG CHANGES.crs || die
	newdoc rules/README README.crs || die
	dohtml -r doc/* || die

	# Prepare the core ruleset
	cd "${S}"/rules/

	sed -i -e 's:logs/:/var/log/apache2/:g' *.conf || die

	insinto ${APACHE_MODULES_CONFDIR}/mod_security/
	for i in *.conf; do
		newins ${i} ${i/modsecurity_crs_/} || die
	done
}
