# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-pdo-odbc/pecl-pdo-odbc-0.9.ebuild,v 1.3 2005/09/16 23:17:27 trapni Exp $

PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_PKG="PDO_ODBC"
PHP_EXT_NAME="pdo_odbc"
PHP_EXT_INI="yes"

inherit php-ext-pecl-r1

IUSE=""
DESCRIPTION="PHP Data Objects (PDO) Driver For ODBC Interface"
SLOT="0"
LICENSE="PHP"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
DEPEND="${DEPEND}
		dev-php5/pecl-pdo
		dev-db/unixODBC"

need_php_by_category

pkg_setup() {
	has_php

	# if the user has compiled in PDO, he can't use this package
	if built_with_use =${PHP_PKG} pdo ; then
		eerror
		eerror "You have built ${PHP_PKG} to use the bundled PDO support."
		eerror "If you want to use the PECL PDO packages, you must rebuild"
		eerror "your PHP with the 'pdo-external' USE flag instead."
		eerror
		die "PHP built to use bundled PDO support"
	fi
}

src_compile() {
	has_php
	my_conf="--with-pdo-odbc=unixODBC,/usr"
	php-ext-pecl-r1_src_compile
}
