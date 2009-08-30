# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/xcache/xcache-1.3.0.ebuild,v 1.1 2009/08/30 06:45:20 hollow Exp $

PHP_EXT_NAME="xcache"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"
PHPSAPILIST="apache2 cgi"

inherit php-ext-source-r1 confutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A fast and stable PHP opcode cacher"
HOMEPAGE="http://xcache.lighttpd.net/"
SRC_URI="http://xcache.lighttpd.net/pub/Releases/${PV}/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
IUSE=""

# make test would just run php's test and as such need the full php source
RESTRICT="test"

DEPEND="!dev-php5/eaccelerator !dev-php5/pecl-apc !dev-php5/ZendOptimizer"
RDEPEND="${DEPEND}"

need_php_by_category

pkg_setup() {
	has_php
	require_php_sapi_from cgi apache2
}

src_compile() {
	has_php

	my_conf="--enable-xcache=shared   \
			--enable-xcache-constant  \
			--enable-xcache-optimizer \
			--enable-xcache-coverager \
			--enable-xcache-assembler \
			--enable-xcache-encoder   \
			--enable-xcache-decoder"

	php-ext-source-r1_src_compile
}

src_install() {
	php-ext-source-r1_src_install
	dodoc-php AUTHORS ChangeLog NEWS README THANKS

	php-ext-base-r1_addtoinifiles "auto_globals_jit" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.size" '"32M"'
	php-ext-base-r1_addtoinifiles "xcache.count" '"2"'
	php-ext-base-r1_addtoinifiles "xcache.slots" '"8k"'
	php-ext-base-r1_addtoinifiles "xcache.ttl" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.gc_interval" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.var_size" '"8M"'
	php-ext-base-r1_addtoinifiles "xcache.var_count" '"1"'
	php-ext-base-r1_addtoinifiles "xcache.var_slots" '"8K"'
	php-ext-base-r1_addtoinifiles "xcache.var_ttl" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.var_maxttl" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.var_gc_interval" '"600"'
	php-ext-base-r1_addtoinifiles "xcache.readonly_protection" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.shm_schema" '"mmap"'
	php-ext-base-r1_addtoinifiles "xcache.mmap_path" '"/dev/zero"'
	php-ext-base-r1_addtoinifiles "xcache.readyonly_protection" '"Off"'
	php-ext-base-r1_addtoinifiles "xcache.cacher" '"On"'
	php-ext-base-r1_addtoinifiles "xcache.stat" '"On"'
	php-ext-base-r1_addtoinifiles "xcache.coverager" '"Off"'
	php-ext-base-r1_addtoinifiles "xcache.coveragedump_directory" '""'
	php-ext-base-r1_addtoinifiles "xcache.optimizer" '"Off"'
	php-ext-base-r1_addtoinifiles "xcache.admin.enable_auth" '"1"'
	php-ext-base-r1_addtoinifiles "xcache.admin.user" '"m0o"'
	php-ext-base-r1_addtoinifiles "xcache.admin.pass" '""'
	php-ext-base-r1_addtoinifiles "xcache.test" '"Off"'
	php-ext-base-r1_addtoinifiles "xcache.experimental" '"Off"'

	insinto "${PHP_EXT_SHARED_DIR}"
	doins Decompiler.class.php
	insinto "${PHP_EXT_SHARED_DIR}/admin"
	doins admin/*
	insinto "${PHP_EXT_SHARED_DIR}/coverager"
	doins coverager/*
}

pkg_postinst() {
	elog "Decompiler.class.php, the admin/ and the coverager/ directory shipped with this"
	elog "release were installed into ${ROOT}usr/share/php5/xcache/."
}
