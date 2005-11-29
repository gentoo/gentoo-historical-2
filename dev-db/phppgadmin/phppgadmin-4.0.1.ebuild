# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/phppgadmin/phppgadmin-4.0.1.ebuild,v 1.1 2005/11/29 01:04:26 rl03 Exp $

inherit webapp

IUSE=""

# This package insists on uppercase letters
MY_P=phpPgAdmin-${PV}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Web-based administration for Postgres database in php"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
HOMEPAGE="http://phppgadmin.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND="virtual/httpd-php"

RDEPEND="${DEPEND}
	!<=dev-db/phppgadmin-3.3.1"

src_install() {
	webapp_src_preinst

	local doc
	local docs="CREDITS DEVELOPERS FAQ HISTORY INSTALL TODO TRANSLATORS"
	dodoc ${docs}
	mv conf/config.inc.php-dist conf/config.inc.php

	cp -r * ${D}${MY_HTDOCSDIR}
	for doc in ${docs} INSTALL LICENSE; do
		rm -f ${D}${MY_HTDOCSDIR}/${doc}
	done

	webapp_configfile ${MY_HTDOCSDIR}/conf/config.inc.php
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_src_install
}
