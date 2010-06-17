# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-htscanner/pecl-htscanner-0.9.0.ebuild,v 1.2 2010/06/17 21:42:06 mabi Exp $

PHP_EXT_NAME="htscanner"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"
PHPSAPILIST="cgi"

inherit php-ext-pecl-r1 eutils depend.php php-ext-base-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Enables .htaccess options for php-scripts running as cgi."
LICENSE="PHP-3"
SLOT="0"
IUSE=""

# functionality is included in >=php-5.3
DEPEND="<dev-lang/php-5.3"
RDEPEND="${DEPEND}"

need_php_by_category
my_conf="--enable-htscanner"

pkg_setup() {
	has_php
	require_php_sapi_from cgi
}

src_install() {
	php-ext-pecl-r1_src_install

	php-ext-base-r1_addtoinifiles "config_file" ".htaccess"
	php-ext-base-r1_addtoinifiles "default_docroot" "/"
	php-ext-base-r1_addtoinifiles "default_ttl" "300"
	php-ext-base-r1_addtoinifiles "stop_on_error" "0"
}
