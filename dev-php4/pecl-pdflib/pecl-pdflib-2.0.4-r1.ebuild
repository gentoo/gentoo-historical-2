# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/pecl-pdflib/pecl-pdflib-2.0.4-r1.ebuild,v 1.1 2005/09/04 15:44:55 stuart Exp $

PHP_EXT_ZENDEXT="no"
PHP_EXT_PECL_PKG="pdflib"
PHP_EXT_NAME="pdf"
PHP_EXT_INI="yes"

inherit php-ext-pecl-r1

IUSE=""
DESCRIPTION="PHP extension for creating PDF files."
SLOT="0"
LICENSE="PHP"
KEYWORDS="~ppc ~x86"
DEPEND="${DEPEND}
		media-libs/pdflib"

need_php_by_category

src_unpack() {
	unpack ${A}

	cd ${S}

	# Patch for http://pecl.php.net/bugs/bug.php?id=3554
	epatch ${FILESDIR}/ifgd-patch.diff
}
