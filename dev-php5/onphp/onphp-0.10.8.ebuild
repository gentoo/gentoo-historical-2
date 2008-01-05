# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/onphp/onphp-0.10.8.ebuild,v 1.3 2008/01/05 23:14:59 voxus Exp $

inherit php-lib-r1

KEYWORDS="amd64 x86"

DESCRIPTION="onPHP is the LGPL'ed multi-purpose object-oriented PHP framework."
HOMEPAGE="http://onphp.org/"
SRC_URI="http://onphp.org/download/${P}.tar.bz2
		doc? ( http://onphp.org/download/${PN}-api-${PV}.tar.bz2 )"
LICENSE="LGPL-3"
SLOT="0"
IUSE="doc"

DEPEND=""
RDEPEND=""

need_php_by_category

src_install() {
	has_php

	dodoc `find doc -maxdepth 1 -type f -print`

	if use doc ; then
		dohtml -r "${WORKDIR}/${PN}-api-${PV}/"*
	fi

	php-lib-r1_src_install ./ global.inc.php.tpl
	php-lib-r1_src_install ./ `find core main meta -type f -print`
}
