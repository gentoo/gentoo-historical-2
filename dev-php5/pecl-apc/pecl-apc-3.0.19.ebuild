# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-apc/pecl-apc-3.0.19.ebuild,v 1.5 2009/11/03 17:33:08 armin76 Exp $

PHP_EXT_NAME="apc"
PHP_EXT_PECL_PKG="APC"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="CHANGELOG INSTALL NOTICE TECHNOTES.txt TODO"

inherit php-ext-pecl-r1 confutils eutils

KEYWORDS="amd64 ~ia64 ppc ~ppc64 sparc x86"

DESCRIPTION="A free, open, and robust framework for caching and optimizing PHP code."
LICENSE="PHP-3.01"
SLOT="0"
IUSE="mmap"

DEPEND="!dev-php5/eaccelerator !dev-php5/xcache"
RDEPEND="${DEPEND}"

need_php_by_category

pkg_setup() {
	require_php_sapi_from cgi apache2
}

src_compile() {
	has_php

	my_conf="--enable-apc"
	enable_extension_enable "apc-mmap" "mmap" 0
	enable_extension_with_built_with =${PHP_PKG} apache2 apxs /usr/sbin/apxs2 "optimisation for apache2"

	php-ext-pecl-r1_src_compile
}

src_install() {
	php-ext-pecl-r1_src_install

	php-ext-base-r1_addtoinifiles "apc.enabled" '"1"'
	php-ext-base-r1_addtoinifiles "apc.shm_segments" '"1"'
	php-ext-base-r1_addtoinifiles "apc.shm_size" '"30"'
	php-ext-base-r1_addtoinifiles "apc.num_files_hint" '"1024"'
	php-ext-base-r1_addtoinifiles "apc.ttl" '"7200"'
	php-ext-base-r1_addtoinifiles "apc.user_ttl" '"7200"'
	php-ext-base-r1_addtoinifiles "apc.gc_ttl" '"3600"'
	php-ext-base-r1_addtoinifiles "apc.cache_by_default" '"1"'
	php-ext-base-r1_addtoinifiles ";apc.filters" '""'
	php-ext-base-r1_addtoinifiles ";apc.mmap_file_mask" '"/tmp/apcphp5.XXXXXX"'
	php-ext-base-r1_addtoinifiles "apc.slam_defense" '"0"'
	php-ext-base-r1_addtoinifiles "apc.file_update_protection" '"2"'
	php-ext-base-r1_addtoinifiles "apc.enable_cli" '"0"'
	php-ext-base-r1_addtoinifiles "apc.max_file_size" '"1M"'
	php-ext-base-r1_addtoinifiles "apc.stat" '"1"'
	php-ext-base-r1_addtoinifiles "apc.write_lock" '"1"'
	php-ext-base-r1_addtoinifiles "apc.report_autofilter" '"0"'
	php-ext-base-r1_addtoinifiles "apc.include_once_override" '"0"'
	php-ext-base-r1_addtoinifiles "apc.rfc1867" '"0"'
	php-ext-base-r1_addtoinifiles "apc.rfc1867_prefix" '"upload_"'
	php-ext-base-r1_addtoinifiles "apc.rfc1867_name" '"APC_UPLOAD_PROGRESS"'
	php-ext-base-r1_addtoinifiles "apc.rfc1867_freq" '"0"'
	php-ext-base-r1_addtoinifiles "apc.localcache" '"0"'
	php-ext-base-r1_addtoinifiles "apc.localcache.size" '"512"'
	php-ext-base-r1_addtoinifiles "apc.coredump_unmap" '"0"'

	dodir "${PHP_EXT_SHARED_DIR}"
	insinto "${PHP_EXT_SHARED_DIR}"
	doins apc.php
}

pkg_postinst() {
	elog "The apc.php file shipped with this release of PECL-APC was"
	elog "installed into ${ROOT}usr/share/php5/apc/."
}
