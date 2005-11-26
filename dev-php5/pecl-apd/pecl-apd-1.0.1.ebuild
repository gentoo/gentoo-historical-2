# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-apd/pecl-apd-1.0.1.ebuild,v 1.4 2005/11/26 23:17:00 chtekk Exp $

PHP_EXT_NAME="apd"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"

inherit php-ext-pecl-r1

KEYWORDS="~sparc ~x86"
DESCRIPTION="A full-featured engine-level profiler/debugger."
LICENSE="PHP"
SLOT="0"
IUSE=""

RDEPEND="${RDEPEND} >=dev-php/PEAR-Console_Getopt-1.2-r1 !dev-php5/ZendOptimizer"

need_php_by_category

pkg_setup() {
	has_php
	require_php_cli
}

src_unpack() {
	unpack ${A}

	cd "${S}"

	epatch "${FILESDIR}/fix-version-string-1.0.1.patch"
}

src_install() {
	sed -i 's:/usr/local/bin/php:/usr/lib/php5/bin/php:g' "${S}/pprofp" || die "Unable to replace PHP path"
	sed -i 's:pprofp:pprofp-php5:g' "${S}/pprofp" || die "Unable to replace PHP path"
	sed -i 's:/usr/bin/env php:/usr/lib/php5/bin/php:g' "${S}/pprof2calltree" || die "Unable to replace PHP path"
	sed -i 's:pprof2calltree:pprof2calltree-php5:g' "${S}/pprof2calltree" || die "Unable to replace PHP path"
	php-ext-pecl-r1_src_install
	newbin pprofp pprofp-php5
	newbin pprof2calltree pprof2calltree-php5
	dodoc-php LICENSE README
}
