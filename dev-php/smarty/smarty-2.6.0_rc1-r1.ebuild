# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/smarty/smarty-2.6.0_rc1-r1.ebuild,v 1.1 2003/09/29 17:49:57 mholzer Exp $

MY_P=Smarty-${PV/_rc/-RC}
DESCRIPTION="A template engine for PHP"
HOMEPAGE="http://smarty.php.net/"
SRC_URI="http://smarty.php.net/distributions/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha arm hppa mips ppc sparc x86"
IUSE="doc"
DEPEND="virtual/php"

S=${WORKDIR}/${MY_P}

src_install() {
	dodoc [A-Z]*
	insinto /usr/lib/php/Smarty
	doins libs/*
	insinto /usr/lib/php/Smarty/core
	doins libs/core/*
	insinto /usr/lib/php/Smarty/plugins
	doins libs/plugins/*
}

pkg_postinst() {
	einfo "Smarty has been installed in /usr/lib/php/Smarty."
	einfo "To use it in your scripts, either"
	einfo "1. define(SMARTY_DIR, \"/usr/lib/php/Smarty\") in your scripts, or"
	einfo "2. add /usr/lib/php/Smarty to includes= in /etc/php4/php.ini"
	einfo
	einfo "You may have to clean up your \"compile_dir\" and \"cache_dir\""
	einfo "in order to get Smarty working correctly."
}
