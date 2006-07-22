# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/onphp-module/onphp-module-0.6.0.ebuild,v 1.2 2006/07/22 12:53:32 voxus Exp $

PHP_EXT_NAME="onphp"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

SRC_URI="http://onphp.org/download/onphp-${PV}.tar.bz2"

KEYWORDS="~amd64 ~x86"
DESCRIPTION="onPHP's module."
LICENSE="GPL-2"
SLOT="0"
IUSE=""

# since need_php51 is missing
DEPEND=">=dev-lang/php-5.1.4"
RDEPEND="${DEPEND}
		~dev-php5/onphp-${PV}"

PHP_VERSION="5"
PHP_SHARED_CAT="php5"

S="${WORKDIR}/onphp-${PV}/ext"

pkg_setup() {
	has_php

	require_php_with_use spl reflection
}

pkg_postinst() {
	einfo
	ewarn "If you're using eAccelerator, you should either upgrade to"
	ewarn "    >dev-php5/eaccelerator-0.9.5_beta2 (not released yet)"
	ewarn "or disable it completely due to \"final constructor\" bug."
	einfo
}
