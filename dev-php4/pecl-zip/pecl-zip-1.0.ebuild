# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/pecl-zip/pecl-zip-1.0.ebuild,v 1.9 2006/01/19 21:16:43 nelchael Exp $

PHP_EXT_NAME="zip"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ppc64 ~s390 ~sparc x86"
DESCRIPTION="PHP zip management extension."
LICENSE="PHP"
SLOT="0"
IUSE=""

DEPEND="${DEPEND}
		dev-libs/zziplib"

need_php_by_category
