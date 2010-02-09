# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-fileinfo/pecl-fileinfo-1.0.4-r1.ebuild,v 1.8 2010/02/09 11:47:00 pacho Exp $

PHP_EXT_NAME="fileinfo"
PHP_EXT_PECL_PKG="Fileinfo"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="amd64 hppa ppc ppc64 sparc x86"

DESCRIPTION="libmagic bindings for PHP."
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND="sys-apps/file"
RDEPEND="${DEPEND}"

src_unpack() {
	PHP_EXT_SKIP_PHPIZE=yes php-ext-source-r1_src_unpack
	epatch "${FILESDIR}"/fileinfo-1.0.4-file-5.0-compat.patch
	php-ext-source-r1_phpize
}

need_php_by_category
