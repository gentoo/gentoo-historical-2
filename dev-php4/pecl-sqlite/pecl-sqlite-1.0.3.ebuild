# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/pecl-sqlite/pecl-sqlite-1.0.3.ebuild,v 1.11 2005/11/25 15:19:07 chtekk Exp $

PHP_EXT_NAME="sqlite"
PHP_EXT_PECL_PKG="SQLite"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
DESCRIPTION="PHP bindings for the SQLite database engine."
LICENSE="PHP"
SLOT="0"
IUSE=""

need_php_by_category

src_install() {
	php-ext-pecl-r1_src_install
	dodoc-php README TODO
}
