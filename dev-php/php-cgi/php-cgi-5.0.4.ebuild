# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cgi/php-cgi-5.0.4.ebuild,v 1.1 2005/06/11 00:19:34 stuart Exp $

PHPSAPI="cgi"
MY_PHP_P="php-${PV}"
PHP_S="${WORKDIR}/${MY_PHP_P}"
PHP_PACKAGE=1

inherit php5-sapi-r2 eutils

DESCRIPTION="PHP Shell Interpreter"
LICENSE="PHP"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
DEPEND="$DEPEND"
RDEPEND="$RDEPEND"
PROVIDE="virtual/php-cgi virtual/php-httpd"
SLOT="0"

PHP_INSTALLTARGETS="install"

src_unpack() {
	php5-sapi-r2_src_unpack

	###########################################################################
	# DO NOT ADD YOUR PATCHES HERE
	#
	# Please add your patches into the eclass, where they belong!
	#
	# Thanks,
	# Stu
	###########################################################################
}

src_compile () {
	my_conf="--disable-cli --enable-cgi"
	php5-sapi-r2_src_compile
}

src_install () {
	php5-sapi-r2_src_install

	# PHP's makefile calls the cgi bin 'php'
	# we need to rename it by hand
	mv ${D}/usr/bin/php ${D}/usr/bin/php-cgi
}
