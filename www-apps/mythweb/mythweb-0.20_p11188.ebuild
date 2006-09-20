# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mythweb/mythweb-0.20_p11188.ebuild,v 1.3 2006/09/20 03:45:13 cardoe Exp $

inherit mythtv webapp depend.php

DESCRIPTION="PHP scripts intended to manage MythTV from a web browser."
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="virtual/httpd-php"

S="${WORKDIR}/mythplugins-${MY_PV}/${PN}"

pkg_setup() {
	webapp_pkg_setup

	if has_version 'dev-lang/php' ; then
		require_php_with_use session mysql pcre
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	mythtv-fixes_patch
}

src_install() {
	webapp_src_preinst

	dodoc README TODO

	dodir ${MY_HTDOCSDIR}/data

	cp -R [[:lower:]]* .htaccess ${D}${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/data

	webapp_configfile ${MY_HTDOCSDIR}/.htaccess

	webapp_postinst_txt en ${FILESDIR}/postinstall-en-0.20.txt

	webapp_src_install
}
