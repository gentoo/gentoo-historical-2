# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mythweb/mythweb-0.19.ebuild,v 1.6 2006/09/16 02:06:50 cardoe Exp $

inherit webapp depend.php

DESCRIPTION="PHP scripts intended to manage MythTV from a web browser."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://ftp.osuosl.org/pub/mythtv/mythplugins-${PV}.tar.bz2"
IUSE=""
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="virtual/httpd-php"

S="${WORKDIR}/mythplugins-${PV}/${PN}"

pkg_setup() {
	webapp_pkg_setup

	if has_version 'dev-lang/php' ; then
		require_php_with_use session mysql
	fi
}

src_install() {
	webapp_src_preinst

	dodoc README TODO

	dodir ${MY_HTDOCSDIR}/data

	cp -R [[:lower:]]* .htaccess ${D}${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/data

	webapp_configfile ${MY_HTDOCSDIR}/config/conf.php
	webapp_configfile ${MY_HTDOCSDIR}/.htaccess
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
