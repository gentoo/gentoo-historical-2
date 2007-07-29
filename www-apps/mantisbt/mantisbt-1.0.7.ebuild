# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mantisbt/mantisbt-1.0.7.ebuild,v 1.3 2007/07/29 17:29:41 phreak Exp $

inherit webapp

IUSE=""
MY_P=mantis-${PV}

DESCRIPTION="PHP/MySQL/Web based bugtracking system"
HOMEPAGE="http://www.mantisbt.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	www-servers/apache
	virtual/httpd-php
"

LICENSE="GPL-2"

src_install() {
	webapp_src_preinst
	rm doc/{LICENSE,INSTALL}
	dodoc doc/*

	cp -R . "${D}"/${MY_HTDOCSDIR}
	rm -rf "${D}"/${MY_HTDOCSDIR}/doc

	mv "${D}"/${MY_HTDOCSDIR}/config_inc.php.sample "${D}"/${MY_HTDOCSDIR}/config_inc.php

	webapp_configfile ${MY_HTDOCSDIR}/config_inc.php
	webapp_postinst_txt en ${FILESDIR}/postinstall-en-1.0.0.txt
	webapp_src_install
}
