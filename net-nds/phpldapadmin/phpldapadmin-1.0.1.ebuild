# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/phpldapadmin/phpldapadmin-1.0.1.ebuild,v 1.2 2006/06/24 19:26:22 chtekk Exp $

inherit webapp depend.php

DESCRIPTION="phpLDAPadmin is a web-based tool for managing all aspects of your LDAP server."
HOMEPAGE="http://phpldapadmin.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"
IUSE=""

need_php5

pkg_setup() {
	webapp_pkg_setup
	require_php_with_use ldap pcre session xml
}

src_unpack() {
	unpack ${A}
	cd ${S}
	mv config/config.php.example config/config.php
}

src_install() {
	webapp_src_preinst

	dodoc doc/*

	cp -r . ${D}${MY_HTDOCSDIR}
	cd ${D}${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/config/config.php

	webapp_postinst_txt en ${FILESDIR}/postinstall2-en.txt

	webapp_src_install
}
