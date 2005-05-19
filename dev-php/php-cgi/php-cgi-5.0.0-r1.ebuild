# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cgi/php-cgi-5.0.0-r1.ebuild,v 1.5 2005/05/19 20:25:58 robbat2 Exp $

PHPSAPI="cgi"
MY_P="php-${PV}"

inherit php5-sapi eutils

DESCRIPTION="PHP CGI"
SLOT="0"
KEYWORDS="~x86"

# provides all base PHP extras (eg PEAR, extension building stuff)
DEPEND_PHP=">=${PHP_PROVIDER_PKG}-5.0.0-r1"
DEPEND="${DEPEND} ${DEPEND_PHP}"
RDEPEND="${RDEPEND} ${DEPEND_PHP}"

PROVIDE="virtual/php virtual/httpd-php"

src_compile() {
	# CLI needed to build stuff
	my_conf="${my_conf} \
		--enable-cgi \
		--enable-cli \
		--enable-fastcgi"

	php5-sapi_src_compile
}


src_install() {
	PHP_INSTALLTARGETS="install"
	php5-sapi_src_install

	# rename binary
	mv ${D}/usr/bin/php ${D}/usr/bin/php-cgi
}

pkg_postinst() {
	einfo "This is a CGI only build."
}
