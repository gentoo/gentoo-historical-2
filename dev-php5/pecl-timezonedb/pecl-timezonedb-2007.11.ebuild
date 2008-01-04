# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-timezonedb/pecl-timezonedb-2007.11.ebuild,v 1.1 2008/01/04 13:26:41 jokey Exp $

PHP_EXT_NAME="timezonedb"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Timezone Database to be used with PHP's date and time functions."
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

need_php_by_category
