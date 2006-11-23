# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mambo/mambo-4.5.4-r2.ebuild,v 1.2 2006/11/23 17:15:39 vivo Exp $

inherit webapp depend.php

WEBAPP_MANUAL_SLOT="yes"
SLOT=4.5.4
MY_PN="${PN/m/M}"
DESCRIPTION="Mambo is yet another CMS"
HOMEPAGE="http://www.mamboserver.com/"
SRC_URI="http://mamboxchange.com/frs/download.php/8203/${MY_PN}v${PV}_wSP2.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
S=${WORKDIR}

IUSE="mysql"

RDEPEND="mysql? ( virtual/mysql )
	virtual/httpd-php
	net-www/apache"

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use mysql zlib
}

src_install () {
	webapp_src_preinst
	local files="administrator/backups administrator/components components
	images images/banners images/stories mambots mambots/content mambots/search
	media language administrator/modules administrator/templates cache modules
	templates"

	dodoc CHANGELOG.php INSTALL.php README

	cp -R [^d]* ${D}/${MY_HTDOCSDIR}

	for file in ${files}; do
		webapp_serverowned "${MY_HTDOCSDIR}/${file}"
	done

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
