# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/egroupware/egroupware-0.9.99.006.ebuild,v 1.1 2003/11/04 23:17:09 mholzer Exp $

inherit webapp-apache

MY_P=eGroupWare-${PV}-0
S=${WORKDIR}/${PN}

DESCRIPTION="Web-based GroupWare suite. It contains many modules"
HOMEPAGE="http://www.eGroupWare.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~amd64 ~sparc ~hppa ~arm"

RDEPEND="virtual/php
	dev-db/mysql"
DEPEND="${RDEPEND}"

webapp-detect || NO_WEBSERVER=1

HTTPD_USER="apache"
HTTPD_GROUP="apache"

pkg_setup() {
	if [ -L ${HTTPD_ROOT}/${PN} ] ; then
		ewarn "You need to unmerge your old egroupware version first."
		ewarn "egroupware will be installed into ${HTTPD_ROOT}/${PN}"
		ewarn "directly instead of a version-dependant directory."
		die "need to unmerge old version first"
	fi
	webapp-pkg_setup "${NO_WEBSERVER}"
	einfo "Installing into ${ROOT}${HTTPD_ROOT}."
}

src_install() {
	local DocumentRoot=${HTTPD_ROOT}
	local destdir=${DocumentRoot}/${PN}
	
	dodir ${destdir}
	cp -r . ${D}${destdir}	
	cd ${D}/${HTTPD_ROOT}
	chown -R ${HTTPD_USER}.${HTTPD_GROUP} ${PN}
	pwd
	ls -la ${PN}/fudforum
	# Fix permissions
	find ${D}${destdir} -type d | xargs chmod 755
	find ${D}${destdir} -type f | xargs chmod 644
	dohtml ${S}/doc/en_US/html/admin/*.html
}

pkg_postinst() {
	einfo "Follow the instructions at /usr/share/doc/${PF}/html/x62.html#AEN134 "
	einfo "to complete the install.  You need to add MySQL users and configure egroupware"
}
