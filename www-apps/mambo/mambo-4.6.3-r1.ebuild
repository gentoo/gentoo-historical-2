# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mambo/mambo-4.6.3-r1.ebuild,v 1.1 2008/01/27 20:41:44 rl03 Exp $

inherit webapp depend.php

MY_PN="${PN/m/M}"
DESCRIPTION="Mambo is a dynamic portal engine and content management system"
HOMEPAGE="http://www.mamboserver.com/"
SRC_URI="http://mambo-code.org/gf/download/frsrelease/274/437/${MY_PN}V${PV}.tar.gz
	http://mambo-code.org/gf/download/frsrelease/298/544/20080110-Mambo46x-SearchPatch.zip"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
S=${WORKDIR}

IUSE=""

RDEPEND="
	virtual/httpd-php
	www-servers/apache"

pkg_setup () {
	webapp_pkg_setup
	require_php_with_use mysql zlib
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	cp -f 20080110-Mambo46x-SearchPatch/components/com_search/* components/com_search
	cp -f 20080110-Mambo46x-SearchPatch/modules/* modules
	rm -rf 20080110-Mambo46x-SearchPatch
}

src_install () {
	webapp_src_preinst
	local files="administrator/backups administrator/components components
	images images/banners images/stories mambots mambots/content mambots/search
	media language administrator/modules administrator/templates cache modules
	templates mambots/editors mambots/editors-xtd uploadfiles"

	dodoc CHANGELOG.php INSTALL.php README

	cp -R [^d]* "${D}/${MY_HTDOCSDIR}"

	for file in ${files}; do
		webapp_serverowned "${MY_HTDOCSDIR}/${file}"
	done

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
