# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/adodb-ext/adodb-ext-504.ebuild,v 1.1 2007/03/08 18:51:15 chtekk Exp $

PHP_EXT_NAME="adodb"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-source-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension providing up to 100% speedup by replacing parts of ADOdb with C code."
HOMEPAGE="http://adodb.sourceforge.net/"
SRC_URI="http://phplens.com/lens/dl/${P}.zip"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=">=dev-php/adodb-4.70"
DEPEND="${RDEPEND}
		app-arch/unzip"

S="${WORKDIR}/adodb-${PV}"

need_php_by_category

src_install() {
	php-ext-source-r1_src_install

	dodir "${PHP_EXT_SHARED_DIR}"
	insinto "${PHP_EXT_SHARED_DIR}"
	doins test-adodb.php

	dodoc-php CREDITS README.txt
}
