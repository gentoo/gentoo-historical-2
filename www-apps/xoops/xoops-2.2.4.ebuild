# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/xoops/xoops-2.2.4.ebuild,v 1.6 2008/02/04 08:38:19 hollow Exp $

inherit webapp depend.php

DESCRIPTION="eXtensible Object Oriented Portal System (xoops) is an open-source
Content Management System, including various portal features and supplemental modules."
HOMEPAGE="http://www.xoops.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-2.2.3a-Final.tar.gz
mirror://sourceforge/${PN}/xoops-2.2.3a-to-2.2.4.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
S=${WORKDIR}

IUSE=""

RDEPEND="virtual/httpd-cgi"
need_php

pkg_setup() {
	if ! PHPCHECKNODIE="yes" require_php_with_use mysql || \
		! PHPCHECKNODIE="yes" require_php_with_any_use apache2 cgi ; then
			die "Re-install ${PHP_PKG} with mysql and at least one of apache2 or cgi flags."
	fi
	webapp_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp -f xoops-2.2.3a-to-2.2.4/docs/* docs/ || die
	cp -Rf xoops-2.2.3a-to-2.2.4/html/* html/ || die
}

src_install() {
	webapp_src_preinst

	dodir ${MY_HOSTROOTDIR}/${PF}
	dodoc docs/changelog.txt
	dohtml docs/INSTALL.html docs/UPDATE.html

	cp -R docs/images "${D}"/usr/share/doc/${PF}/html
	cp -pPR html/* "${D}/${MY_HTDOCSDIR}"
	cp -pPR extras/* "${D}"/${MY_HOSTROOTDIR}/${PF}

	webapp_serverowned ${MY_HTDOCSDIR}/uploads
	webapp_serverowned ${MY_HTDOCSDIR}/cache
	webapp_serverowned ${MY_HTDOCSDIR}/templates_c
	webapp_configfile ${MY_HTDOCSDIR}/mainfile.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
