# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/online-bookmarks/online-bookmarks-0.6.9.ebuild,v 1.2 2006/11/23 17:20:29 vivo Exp $

inherit webapp depend.php

S=${WORKDIR}/${PN}

DESCRIPTION="A Bookmark management system to store your Bookmarks, Favorites and Links right in the WWW where they actually belong"
HOMEPAGE="http://www.frech.ch/online-bookmarks/index.php"
SRC_URI="http://www.frech.ch/online-bookmarks/download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

IUSE="mysql"

RDEPEND=">=virtual/httpd-php-4.3.0
	mysql? ( virtual/mysql )
	dev-php/PEAR-Auth
	dev-php/PEAR-DB
"

src_unpack() {
	unpack ${A}
	require_php_with_use mysql
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	webapp_src_preinst

	dodoc CHANGES README

	cp -R * "${D}/${MY_HTDOCSDIR}"

	webapp_configfile "${MY_HTDOCSDIR}/login.php"

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_src_install
}
