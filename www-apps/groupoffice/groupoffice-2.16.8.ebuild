# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/groupoffice/groupoffice-2.16.8.ebuild,v 1.3 2007/01/19 07:10:40 jer Exp $

inherit eutils webapp depend.php versionator

MY_PV=$(replace_version_separator 2 '-' )
S=${WORKDIR}/${PN}-com-${MY_PV}
DESCRIPTION="Group-Office is a powerful modular Intranet application framework"
HOMEPAGE="http://group-office.sourceforge.net/"
SRC_URI="mirror://sourceforge/group-office/${PN}-com-${MY_PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

need_php

pkg_setup() {
	webapp_pkg_setup
	elog "PHP needs to be compiled with iconv support"
	elog "If you are using php-4*, be sure it's compiled with USE=nls"
	elog "If you are using php-5*, be sure it's compiled with USE=iconv"
	require_php_with_use imap mysql calendar
}

src_install() {
	webapp_src_preinst

	local docs="CHANGELOG DEVELOPERS FAQ README README.ldap TODO TRANSLATORS"

	dodoc ${docs} RELEASE LICENSE.*

	cp -r . ${D}${MY_HTDOCSDIR}
	for doc in ${docs}; do
		rm -f ${D}${MY_HTDOCSDIR}/${doc}
	done

	touch ${D}${MY_HTDOCSDIR}/config.php
	dodir ${MY_HOSTROOTDIR}/${P}/userdata ${MY_HTDOCSDIR}/local

	webapp_serverowned ${MY_HTDOCSDIR}
	webapp_serverowned -R ${MY_HOSTROOTDIR}/${P}/userdata
	webapp_serverowned ${MY_HTDOCSDIR}/local
	webapp_configfile ${MY_HTDOCSDIR}/config.php

	webapp_postinst_txt en ${FILESDIR}/postinstall2-en.txt
	webapp_src_install
}
