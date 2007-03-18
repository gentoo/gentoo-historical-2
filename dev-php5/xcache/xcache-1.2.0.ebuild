# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/xcache/xcache-1.2.0.ebuild,v 1.5 2007/03/18 03:24:25 chtekk Exp $

PHP_EXT_NAME="xcache"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"

inherit php-ext-source-r1 confutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Another PHP opcode cache and encoder."
HOMEPAGE="http://trac.lighttpd.net/xcache/"
SRC_URI="http://210.51.190.228/pub/XCache/Releases/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="!dev-php5/eaccelerator !dev-php5/pecl-apc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

need_php_by_category

pkg_setup() {
	has_php
	require_php_sapi_from cgi apache apache2
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

	enable_extension_with_built_with =${PHP_PKG} apache2 apxs2 /usr/sbin/apxs2 "optimisation for apache2"
	enable_extension_with_built_with =${PHP_PKG} apache apxs /usr/sbin/apxs "optimisation for apache1"

	php-ext-source-r1_src_compile
}

src_install() {
	php-ext-source-r1_src_install
	dodoc-php AUTHORS CHANGELOG INSTALL COPYING

	php-ext-base-r1_addtoinifiles "auto_globals_jit" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.cacher" '"1"'
	php-ext-base-r1_addtoinifiles "xcache.size" '"10M"'
	php-ext-base-r1_addtoinifiles "xcache.count" '"2"'
	php-ext-base-r1_addtoinifiles "xcache.slots" '"8k"'
	php-ext-base-r1_addtoinifiles "xcache.var_size" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.var_count" '"1"'
	php-ext-base-r1_addtoinifiles "xcache.readonly_protection" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.mmap_path" '"/dev/zero"'
	php-ext-base-r1_addtoinifiles "xcache.stat" '"1"'
	php-ext-base-r1_addtoinifiles "xcache.optimizer" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.coverager" '"0"'
	php-ext-base-r1_addtoinifiles "xcache.coveragedump_directory" '""'

	dodir "${PHP_EXT_SHARED_DIR}"
	insinto "${PHP_EXT_SHARED_DIR}"
	doins Decompiler.class.php
	dodir "${PHP_EXT_SHARED_DIR}/admin"
	insinto "${PHP_EXT_SHARED_DIR}/admin"
	doins admin/*
}

pkg_postinst() {
	elog "Decompiler.class.php and the admin/ directory shipped with this"
	elog "release were installed into ${ROOT}usr/share/php5/xcache/."
}
