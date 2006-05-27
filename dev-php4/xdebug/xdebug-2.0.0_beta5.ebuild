# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php4/xdebug/xdebug-2.0.0_beta5.ebuild,v 1.2 2006/05/27 00:46:36 chtekk Exp $

PHP_EXT_NAME="xdebug"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"

inherit php-ext-source-r1

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
DESCRIPTION="A PHP Debugging and Profiling extension."
HOMEPAGE="http://www.xdebug.org/"
LICENSE="Xdebug"
SLOT="0"
IUSE=""

MY_P="${P/_/}"
SRC_URI="http://pecl.php.net/get/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

RDEPEND="${RDEPEND} !dev-php4/ZendOptimizer"

need_php_by_category

src_install() {
	php-ext-source-r1_src_install
	dodoc-php NEWS README Changelog CREDITS LICENSE
}
