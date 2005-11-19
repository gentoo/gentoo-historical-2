# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/pecl-zip/pecl-zip-1.0.ebuild,v 1.6 2005/11/19 20:26:18 corsair Exp $

PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_PKG="zip"
PHP_EXT_NAME="zip"
PHP_EXT_INI="yes"

inherit php-ext-pecl-r1

IUSE=""
DESCRIPTION="PHP zip management extension."
SLOT="0"
LICENSE="PHP"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
DEPEND="${DEPEND}
		dev-libs/zziplib"

need_php_by_category
