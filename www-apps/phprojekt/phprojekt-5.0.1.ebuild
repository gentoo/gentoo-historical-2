# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phprojekt/phprojekt-5.0.1.ebuild,v 1.3 2005/10/31 14:03:42 rl03 Exp $

inherit webapp

DESCRIPTION="Project management and coordination system"
HOMEPAGE="http://www.phprojekt.com/"
SRC_URI="http://phprojekt.com/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~ppc ~x86"
IUSE="postgres mysql"

S=${WORKDIR}/${PN}

RDEPEND="net-www/apache
		postgres? ( dev-db/postgresql )
		mysql? ( dev-db/mysql )
		virtual/php"

pkg_setup () {
	webapp_pkg_setup
	einfo "Please make sure that your PHP is compiled with support for IMAP and your database of choice"
}

src_install() {
	webapp_src_preinst
	local file

	cp -R . ${D}/${MY_HTDOCSDIR}
	for file in attach chat; do
		webapp_serverowned ${MY_HTDOCSDIR}/${file}
	done
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
