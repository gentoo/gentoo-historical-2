# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/sqlite-php/sqlite-php-0.0.5.ebuild,v 1.11 2004/07/06 23:02:14 hansmi Exp $

DESCRIPTION="PHP bindings for SQLite"
SRC_URI="mirror://sourceforge/sqlite-php/${P}.tgz"
HOMEPAGE="http://sourceforge.net/projects/sqlite-php/"
DEPEND="virtual/libc
	>=dev-php/php-4.2
	>=dev-db/sqlite-2.7
	!dev-php/PECL-sqlite"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""
PHP_EXT_NAME="sqlite"
PHP_ZEND_EXT=

inherit php-ext-source

src_compile() {
	myconf="${myconf} --with-sqlite=shared"
	php-ext-source_src_compile
}

src_install () {

	php-ext-source_src_install
	dodoc README CREDITS CHANGES

}
