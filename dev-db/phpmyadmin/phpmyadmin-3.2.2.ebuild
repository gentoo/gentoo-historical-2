# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/phpmyadmin/phpmyadmin-3.2.2.ebuild,v 1.1 2009/09/18 08:28:12 scarabeus Exp $

EAPI="2"

inherit eutils webapp depend.php

MY_PV=${PV/_/-}
MY_P="phpMyAdmin-${MY_PV}-all-languages"

DESCRIPTION="Web-based administration for MySQL database in PHP"
HOMEPAGE="http://www.phpmyadmin.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/mysql-5.0"
RDEPEND="
	dev-lang/php[crypt,ctype,filter,pcre,session,spl,unicode]
	|| (
		dev-lang/php[mysqli]
		dev-lang/php[mysql]
	)
"

need_httpd_cgi
need_php_httpd

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	dodoc CREDITS Documentation.txt INSTALL README RELEASE-DATE-${MY_PV} TODO ChangeLog || die
	rm -f LICENSE CREDITS INSTALL README RELEASE-DATE-${MY_PV} TODO

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/libraries/config.default.php
	webapp_serverowned "${MY_HTDOCSDIR}"/libraries/config.default.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-3.1.txt
	webapp_hook_script "${FILESDIR}"/reconfig-2.8
	webapp_src_install
}
