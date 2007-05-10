# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phpwiki/phpwiki-1.3.10-r3.ebuild,v 1.1 2007/05/10 12:57:53 wrobel Exp $

inherit eutils webapp

DESCRIPTION="PhpWiki is a WikiWikiWeb clone in PHP"
HOMEPAGE="http://phpwiki.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz http://dev.gentoo.org/~stuart/patches/${PN}-xmlrpc.tar.gz"

LICENSE="GPL-2"
KEYWORDS="ppc ~sparc ~x86"
IUSE=""

RDEPEND="virtual/php
	net-www/apache"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/phpwiki-1.3.10-xmlrpc.patch
	rm -f Makefile LICENSE

	# patch for XMLRPC vulnerabilities
	cp -f ${WORKDIR}/phpwiki-xmlrpc/* lib/XMLRPC/
}

src_install() {
	webapp_src_preinst

	cp -pPR * ${D}/${MY_HTDOCSDIR}
	rm -rf ${D}/${MY_HTDOCSDIR}/{doc,schemas,README,INSTALL,UPGRADING}

	# Fix for security issue (Gentoo bug #174451 and http://secunia.com/advisories/24888/)
	rm -rf ${D}/${MY_HTDOCSDIR}/lib/plugin/UpLoad.php

	dodoc README INSTALL UPGRADING doc/* schemas/*

	# Create config file from distribution default, and fix up invalid defaults
	cd ${D}/${MY_HTDOCSDIR}/config
	sed "s:;DEBUG = 1:DEBUG = 0:" config-dist.ini > config.ini

	webapp_postinst_txt en ${FILESDIR}/postinstall-1.3-en.txt
	webapp_configfile ${MY_HTDOCSDIR}/config/config.ini

	webapp_src_install
}
