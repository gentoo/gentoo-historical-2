# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cgi/php-cgi-5.0.3.ebuild,v 1.1 2004/12/16 06:46:47 robbat2 Exp $

PHPSAPI="cgi"
MY_P="php-${PV}"

inherit php5-sapi eutils

DESCRIPTION="PHP CGI"
SLOT="0"
KEYWORDS="~ia64 ~ppc ~x86 ~ppc64"

# provides all base PHP extras (eg PEAR, extension building stuff)
DEPEND_PHP=">=${PHP_PROVIDER_PKG}-5.0.3"
DEPEND="${DEPEND} ${DEPEND_PHP}"
RDEPEND="${RDEPEND} ${DEPEND_PHP}"

PROVIDE="virtual/php-${PV} virtual/httpd-php-${PV}"

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

	rm -f ${D}/usr/bin/php
	# rename binary
	newbin ${S}/sapi/cgi/php php-cgi
}

pkg_postinst() {
	einfo "This is a CGI only build."
}
