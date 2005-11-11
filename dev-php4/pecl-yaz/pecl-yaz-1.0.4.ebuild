# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/pecl-yaz/pecl-yaz-1.0.4.ebuild,v 1.6 2005/11/11 02:06:45 vapier Exp $

PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_PKG="yaz"
PHP_EXT_NAME="yaz"
PHP_EXT_INI="yes"

inherit php-ext-pecl-r1

DESCRIPTION="This extension implements a Z39.50 client for PHP using the YAZ toolkit."
LICENSE="PHP"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~s390 ~sparc ~x86"
IUSE=""

DEPEND="${DEPEND}
		>=dev-libs/yaz-2.0.13"

need_php_by_category

src_compile() {
	has_php
	my_conf="--with-yaz=/usr"
	php-ext-pecl-r1_src_compile
}
