# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cgi/php-cgi-5.0.3-r1.ebuild,v 1.3 2005/05/19 20:25:58 robbat2 Exp $

PHPSAPI="cgi"
MY_P="php-${PV}"

inherit php5-sapi eutils

DESCRIPTION="PHP CGI"
SLOT="0"
IUSE="${IUSE} force-cgi-redirect"
KEYWORDS="~ia64 ~ppc ~x86 ~ppc64 ~sparc ~amd64"

# provides all base PHP extras (eg PEAR, extension building stuff)
DEPEND_PHP=">=${PHP_PROVIDER_PKG}-5.0.3"
DEPEND="${DEPEND} ${DEPEND_PHP}"
RDEPEND="${RDEPEND} ${DEPEND_PHP}"

PROVIDE="virtual/php virtual/httpd-php"

src_unpack() {
	php5-sapi_src_unpack
	[ "${ARCH}" == "sparc" ] && epatch ${FILESDIR}/stdint.diff
	epatch ${FILESDIR}/${P}-missing-arches.patch
}

src_compile() {
	# CLI needed to build stuff
	my_conf="${my_conf} \
		--enable-cgi \
		--enable-cli \
		--enable-fastcgi"

	if use force-cgi-redirect; then
		my_conf="${my_conf} --enable-force-cgi-redirect"
	fi

	php5-sapi_src_compile
}


src_install() {
	PHP_INSTALLTARGETS="install"
	php5-sapi_src_install

	rm -f ${D}/usr/bin/php
	# rename binary
	newbin ${S}/sapi/cgi/php php-cgi
}

pkg_postinst() {
	einfo "This is a CGI only build."
}
