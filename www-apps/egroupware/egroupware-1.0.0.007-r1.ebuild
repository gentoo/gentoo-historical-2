# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/egroupware/egroupware-1.0.0.007-r1.ebuild,v 1.3 2005/07/08 08:28:14 kloeri Exp $

inherit webapp eutils

MY_P=eGroupWare-${PV}-2
S=${WORKDIR}/${PN}

DESCRIPTION="Web-based GroupWare suite. It contains many modules"
HOMEPAGE="http://www.eGroupWare.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ~hppa ppc ~sparc ~x86"
IUSE="ldap"

RDEPEND="virtual/php
	|| ( >=dev-db/mysql-3.23 >=dev-db/postgresql-7.2 )
	ldap? ( net-nds/openldap )
	net-www/apache"

pkg_setup () {
	webapp_pkg_setup
	einfo "Please make sure that your PHP is compiled with LDAP (if using openldap), IMAP, and MySQL|PostgreSQL support"
	einfo
	einfo "Consider installing an MTA if you want to take advantage of eGW's mail capabilities."
}

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch ${FILESDIR}/${PN}-1.0.0.007-xmlrpc.patch
}

src_install() {
	webapp_src_preinst
	cd ${S}
	# remove CVS directories
	find . -type d -name 'CVS' -print | xargs rm -rf
	cp -r . ${D}/${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/fudforum
	webapp_serverowned ${MY_HTDOCSDIR}/phpgwapi/images

	# add post-installation instructions
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
