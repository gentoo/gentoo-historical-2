# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ZendFramework/ZendFramework-0.1.5.ebuild,v 1.3 2006/09/13 19:08:35 sebastian Exp $

inherit php-lib-r1

DESCRIPTION="Zend Framework is a high quality and open source framework for developing Web Applications and Web Services with PHP 5."
HOMEPAGE="http://framework.zend.com/"
SRC_URI="http://framework.zend.com/releases/${P}.tar.gz"

LICENSE="ZendFramework-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples"

PHP_LIB_NAME="Zend"

need_php_by_category

src_install() {
	php-lib-r1_src_install library/Zend `cd library/Zend ; find . -type f -print`
	php-lib-r1_src_install incubator/library/Zend `cd incubator/library/Zend ; find . -type f -print`

	insinto /usr/share/${PHP_SHARED_CAT}
	doins library/Zend.php

	if use examples ; then
		insinto /usr/share/doc/${P}
		doins -r demos
	fi

	if use doc ; then
		insinto /usr/share/doc/${P}
		dodoc *.txt
		dohtml -r documentation/*
	fi
}
