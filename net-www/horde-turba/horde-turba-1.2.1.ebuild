# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/horde-turba/horde-turba-1.2.1.ebuild,v 1.7 2004/01/19 06:38:44 vapier Exp $

inherit webapp-apache

MY_P=${P/horde-/}
DESCRIPTION="Turba is the Horde address book / contact management program"
HOMEPAGE="http://www.horde.org/"
SRC_URI="ftp://ftp.horde.org/pub/turba/tarballs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND=""
RDEPEND=">=net-www/horde-2.2.4"

S=${WORKDIR}/${MY_P}

webapp-detect || NO_WEBSERVER=1

pkg_setup() {
	GREPBACKEND=`egrep 'sql|odbc|postgres|ldap' /var/db/pkg/dev-php/mod_php*/USE`
	if [ -z "${GREPBACKEND}" ] ; then
		eerror "Missing SQL or LDAP support in mod_php !"
		die "aborting..."
	fi

	webapp-pkg_setup "${NO_WEBSERVER}"
	einfo "Installing into ${ROOT}${HTTPD_ROOT}."

	export REGISTRY=${HTTPD_ROOT}/horde/config/registry.php
	[ -f ${REGISTRY} ] || REGISTRY=${HTTPD_ROOT}/horde/config/registry.php.dist
	[ -f ${REGISTRY} ] || die "${REGISTRY} not found"
}

src_install() {
	webapp-mkdirs

	local DocumentRoot=${HTTPD_ROOT}
	local destdir=${DocumentRoot}/horde/turba

	dodoc COPYING README docs/*
	rm -rf COPYING README docs

	dodir ${destdir}
	cp -r . ${D}${destdir}
	cd ${D}/${HTTPD_ROOT}/horde

	# protecting files
	chown -R ${HTTPD_USER}:${HTTPD_GROUP} turba
	find ${D}/${destdir} -type f -exec chmod 0640 {} \;
	find ${D}/${destdir} -type d -exec chmod 0750 {} \;
}

pkg_postinst() {
	einfo "Please read /usr/share/doc/${PF}/INSTALL.gz !"
}
