# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/xdebug/xdebug-1.3.0_rc1.ebuild,v 1.1 2003/09/18 19:53:42 coredumb Exp $

PHP_EXT_ZENDEXT="yes"
PHP_EXT_NAME="xdebug"

inherit php-ext-source

IUSE=""
DESCRIPTION="A PHP debugger"
HOMEPAGE="http://xdebug.derickrethans.nl"
SLOT="0"
SRC_URI="http://files.derickrethans.nl/${PN}-1.3.0rc1.tgz"
S="${WORKDIR}/${PN}-1.3.0rc1"
LICENSE="Xdebug"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

src_install() {
php-ext-source_src_install
dodoc NEWS README Changelog CREDITS LICENSE
}
