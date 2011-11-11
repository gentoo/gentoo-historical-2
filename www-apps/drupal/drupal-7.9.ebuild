# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/drupal/drupal-7.9.ebuild,v 1.1 2011/11/11 04:56:32 radhermit Exp $

EAPI=4

inherit webapp depend.php

MY_PV=${PV:0:3}.0

DESCRIPTION="PHP-based open-source platform and content management system"
HOMEPAGE="http://drupal.org/"
SRC_URI="http://drupal.org/files/projects/${P/_/-}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="+mysql postgres sqlite"

need_httpd_cgi
need_php_httpd

RDEPEND="dev-lang/php[pdo,postgres?,sqlite?,xml]
	mysql? ( || ( dev-lang/php[mysql] dev-lang/php[mysqli] ) )
	|| ( dev-lang/php[gd] dev-lang/php[gd-external] )"

REQUIRED_USE="|| ( mysql postgres sqlite )"

S="${WORKDIR}/${P/_/-}"

src_install() {
	webapp_src_preinst

	local docs="MAINTAINERS.txt LICENSE.txt INSTALL.txt CHANGELOG.txt INSTALL.mysql.txt INSTALL.pgsql.txt INSTALL.sqlite.txt UPGRADE.txt "
	dodoc ${docs}
	rm -f ${docs} INSTALL COPYRIGHT.txt

	cp sites/default/{default.settings.php,settings.php}
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	dodir "${MY_HTDOCSDIR}"/files
	webapp_serverowned "${MY_HTDOCSDIR}"/files
	webapp_serverowned "${MY_HTDOCSDIR}"/sites/default
	webapp_serverowned "${MY_HTDOCSDIR}"/sites/default/settings.php

	webapp_configfile "${MY_HTDOCSDIR}"/sites/default/settings.php
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}

pkg_postinst() {
	ewarn
	ewarn "SECURITY NOTICE"
	ewarn "If you plan on using SSL on your Drupal site, please consult the postinstall information:"
	ewarn "\t# webapp-config --show-postinst ${PN} ${PV}"
	ewarn
}
