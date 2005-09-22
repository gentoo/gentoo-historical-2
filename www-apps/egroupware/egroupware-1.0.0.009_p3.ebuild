# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/egroupware/egroupware-1.0.0.009_p3.ebuild,v 1.2 2005/09/22 10:26:15 rl03 Exp $

inherit webapp #depend.php

MY_P=eGroupWare-${PV/_p3}-3
S=${WORKDIR}/${PN}

DESCRIPTION="Web-based GroupWare suite"
HOMEPAGE="http://www.eGroupWare.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc x86"
IUSE="gd ldap"

RDEPEND="virtual/php
	|| ( >=dev-db/mysql-3.23 >=dev-db/postgresql-7.2 )
	ldap? ( net-nds/openldap )
	gd? ( media-libs/gd )
	net-www/apache"

pkg_setup () {
	webapp_pkg_setup

#	require_php_with_use imap
	einfo "Your PHP needs to be compiled with IMAP support"

	if useq ldap; then
#		require_php_with_use ldap
		einfo "Your PHP needs to be compiled with LDAP support"
	fi

	einfo "Please make sure that your PHP is compiled with MySQL|PostgreSQL support"
	einfo
	einfo "Consider installing an MTA if you want to use eGW's mail capabilities."
}

src_unpack() {
	unpack ${A}
	cd ${S}
	# remove CVS directories
	find . -type d -name 'CVS' -print | xargs rm -rf
}

src_install() {
	webapp_src_preinst
	cp -r . ${D}/${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/fudforum
	webapp_serverowned ${MY_HTDOCSDIR}/phpgwapi/images

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_src_install
}
