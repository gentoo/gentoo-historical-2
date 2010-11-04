# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-fileinfo/pecl-fileinfo-1.0.4-r2.ebuild,v 1.1 2010/11/04 12:02:21 mabi Exp $

EAPI="3"

PHP_EXT_NAME="fileinfo"
PHP_EXT_PECL_PKG="Fileinfo"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="libmagic bindings for PHP."
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND="sys-apps/file"
RDEPEND="${DEPEND}"

# fileinfo is bundled with php5.3
USE_PHP="php5-2"

src_prepare() {
	for slot in $(php_get_slots) ; do
		cd "${WORKDIR}/${slot}"
		epatch "${FILESDIR}"/fileinfo-1.0.4-file-5.0-compat.patch
	done
	php-ext-source-r2_src_prepare
}
