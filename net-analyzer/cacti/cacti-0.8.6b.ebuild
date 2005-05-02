# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/cacti/cacti-0.8.6b.ebuild,v 1.8 2005/05/02 11:23:48 eldad Exp $

inherit eutils webapp

DESCRIPTION="Cacti is a complete frontend to rrdtool"
HOMEPAGE="http://www.cacti.net/"
SRC_URI="http://www.cacti.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc sparc ~alpha ~amd64"
IUSE="snmp"

DEPEND=""

# TODO: RDEPEND Not just apache... but there's no virtual/webserver (yet)

RDEPEND="net-www/apache
	snmp? ( net-analyzer/net-snmp )
	net-analyzer/rrdtool
	dev-db/mysql
	virtual/cron
	dev-php/php
	dev-php/mod_php"

pkg_setup() {
	webapp_pkg_setup
	built_with_use dev-php/php mysql || \
		die "dev-php/php must be compiled with USE=mysql"
	built_with_use dev-php/mod_php mysql || \
		die "dev-php/mod_php must be compiled with USE=mysql"
}

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	webapp_src_preinst

	dodoc LICENSE
	rm LICENSE README

	dodoc docs/{CHANGELOG,CONTRIB,INSTALL,README,REQUIREMENTS,UPGRADE}
	rm -rf docs

	edos2unix `find -type f -name '*.php'`

	dodir ${MY_HTDOCSDIR}
	cp -r . ${D}${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/include/config.php
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}

