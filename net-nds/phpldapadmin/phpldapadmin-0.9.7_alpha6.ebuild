# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/phpldapadmin/phpldapadmin-0.9.7_alpha6.ebuild,v 1.4 2005/12/13 00:00:17 rl03 Exp $

inherit eutils webapp

MY_P=${P/_alpha/-alpha}

DESCRIPTION="phpLDAPadmin is a web-based tool for managing all aspects of your LDAP server."
HOMEPAGE="http://phpldapadmin.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ~ppc ~sparc x86"
IUSE=""
S=${WORKDIR}/${MY_P}

DEPEND="virtual/php"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv config.php.example config.php
	epatch ${FILESDIR}/welcome.php.patch
}

src_install() {
	webapp_src_preinst

	dodoc doc/*

	cp -r . ${D}${MY_HTDOCSDIR}
	cd ${D}${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/config.php

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
