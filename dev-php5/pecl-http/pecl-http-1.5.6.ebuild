# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-http/pecl-http-1.5.6.ebuild,v 1.1 2007/10/10 20:56:45 anant Exp $

PHP_EXT_NAME="http"
PHP_EXT_PECL_PKG="pecl_http"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="docs/examples/tutorial.txt"

inherit php-ext-pecl-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Extended HTTP Support for PHP."
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="net-misc/curl
		sys-libs/zlib"
RDEPEND="${DEPEND}"

need_php_by_category

src_compile() {
	my_conf="--enable-http \
			--with-http-curl-requests \
			--with-http-zlib-compression"

	php-ext-pecl-r1_src_compile
}

pkg_postinst() {
	has_php
	if ! built_with_use --missing true =${PHP_PKG} hash iconv session spl ; then
		elog "${PN} can optionally use hash, iconv, session and spl features."
		elog "If you want those, recompile ${PHP_PKG} with those flags in USE."
	fi
}
