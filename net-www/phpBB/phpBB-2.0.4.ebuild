# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tim Raedisch <tim.raedisch@udo.edu>
# $Header: /var/cvsroot/gentoo-x86/net-www/phpBB/phpBB-2.0.4.ebuild,v 1.3 2003/08/03 19:20:42 stuart Exp $

S=${WORKDIR}/${PN}2
DESCRIPTION="phpBB is a high powered, fully scalable, and highly customisable open-source bulletin board package."
HOMEPAGE="http://www.phpbb.com/"
SRC_URI="http://belnet.dl.sourceforge.net/sourceforge/phpbb/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="virtual/php"

# this is the eclass that handles apache-specific stuff

inherit webapp-apache

# these are the functions provided by the webapp eclass solution

webapp-determine-installowner
webapp-determine-htdocsdir

pkg_setup() {
	if [ -d "${HTTPD_ROOT}/phpbb" ] ; then
		ewarn "You need to unmerge your old phpBB version first."
		ewarn "phpBB will be installed into ${HTTPD_ROOT}/phpbb"
		ewarn "directly instead of a version-dependant directory."
		die "need to unmerge old version first"
	fi

	einfo "Installing for ${WEBAPP_SERVER}"
}

src_compile() {            
	#we need to have this empty function ... default compile hangs
	echo "Nothing to compile" 
}

src_install() {
	cd ${S}
	dodir "${HTTPD_ROOT}/phpbb"
	cp -a * "${D}/${HTTPD_ROOT}/phpbb"
	chown -R "${HTTPD_USER}.${HTTPD_GROUP}" "${D}/${HTTPD_ROOT}/phpbb"
	dodoc "${S}/docs/*"
}


