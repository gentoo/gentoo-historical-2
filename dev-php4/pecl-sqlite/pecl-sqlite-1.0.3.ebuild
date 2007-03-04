# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/pecl-sqlite/pecl-sqlite-1.0.3.ebuild,v 1.21 2007/03/04 21:01:55 chtekk Exp $

PHP_EXT_NAME="sqlite"
PHP_EXT_PECL_PKG="SQLite"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

DESCRIPTION="PHP bindings for the SQLite database engine."
LICENSE="PHP"
SLOT="0"
IUSE=""

DEPEND="=dev-db/sqlite-2*"
RDEPEND="${DEPEND}"

need_php_by_category

src_unpack() {
	unpack ${A}
	cd "${S}"
	# There is a copy of the sqlite2 sources, so
	# we make sure the bundled copy is never used
	# https://bugs.gentoo.org/show_bug.cgi?id=159207
	rm -Rf libsqlite
}

src_compile() {
	has_php
	my_conf="--with-sqlite=/usr"
	php-ext-pecl-r1_src_compile
}
