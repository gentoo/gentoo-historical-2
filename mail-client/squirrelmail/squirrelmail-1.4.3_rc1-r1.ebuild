# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/squirrelmail/squirrelmail-1.4.3_rc1-r1.ebuild,v 1.3 2004/07/14 16:33:05 agriffis Exp $

IUSE="crypt ldap ssl virus-scan"

inherit webapp eutils

DESCRIPTION="Webmail for nuts!"

# Plugin Versions
COMPATIBILITY_VER=1.3
USERDATA_VER=0.9-1.4.0
ADMINADD_VER=0.1-1.4.0
VSCAN_VER=0.5-1.4.0
GPG_VER=2.0.1-1.4.2
LDAP_VER=0.4
SECURELOGIN_VER=1.2-1.2.8
SHOWSSL_VER=2.1-1.2.8

MY_P=${P/_rc/-RC}
S="${WORKDIR}/${MY_P}"

PLUGINS_LOC="http://www.squirrelmail.org/plugins"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
	mirror://sourceforge/retruserdata/retrieveuserdata.${USERDATA_VER}.tar.gz
	${PLUGINS_LOC}/compatibility-${COMPATIBILITY_VER}.tar.gz
	ssl? ( ${PLUGINS_LOC}/secure_login-${SECURELOGIN_VER}.tar.gz )
	ssl? ( ${PLUGINS_LOC}/show_ssl_link-${SHOWSSL_VER}.tar.gz )
	${PLUGINS_LOC}/admin_add.${ADMINADD_VER}.tar.gz
	virus-scan? ( ${PLUGINS_LOC}/virus_scan.${VSCAN_VER}.tar.gz )
	crypt? ( ${PLUGINS_LOC}/gpg.${GPG_VER}.tar.gz )
	ldap? ( ${PLUGINS_LOC}/ldapuserdata-${LDAP_VER}.tar.gz )"

HOMEPAGE="http://www.squirrelmail.org/"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~alpha"

DEPEND="virtual/php
	dev-perl/DB_File
	crypt? ( app-crypt/gnupg )
	ldap? ( net-nds/openldap )"

src_unpack() {
	unpack ${MY_P}.tar.bz2

	cd ${S}
	mv config/config_default.php config/config.php
	epatch ${FILESDIR}/${PN}-fortune.patch

	# Now do the plugins
	cd ${S}/plugins

	unpack compatibility-${COMPATIBILITY_VER}.tar.gz

	unpack admin_add.${ADMINADD_VER}.tar.gz

	unpack retrieveuserdata.${USERDATA_VER}.tar.gz

	use virus-scan &&
		unpack virus_scan.${VSCAN_VER}.tar.gz &&
		mv virus_scan/config.php.sample virus_scan/config.php

	use crypt &&
		unpack gpg.${GPG_VER}.tar.gz

	use ldap &&
		unpack ldapuserdata-${LDAP_VER}.tar.gz &&
		epatch ${FILESDIR}/ldapuserdata-${LDAP_VER}-gentoo.patch &&
		mv ldapuserdata/config_sample.php ldapuserdata/config.php

	use ssl &&
		unpack secure_login-${SECURELOGIN_VER}.tar.gz &&
		mv secure_login/config.php.sample secure_login/config.php &&
		unpack show_ssl_link-${SHOWSSL_VER}.tar.gz &&
		mv show_ssl_link/config.php.sample show_ssl_link/config.php
}

src_compile() {
	#we need to have this empty function ... default compile hangs
	echo "Nothing to compile"
}

src_install() {
	webapp_src_preinst

	# handle documentation files
	#
	# NOTE that doc files go into /usr/share/doc as normal; they do NOT
	# get installed per vhost!

	for doc in AUTHORS COPYING ChangeLog INSTALL README ReleaseNotes UPGRADE; do
		dodoc ${doc}
		rm -f ${doc}
	done

	docinto compatibility
	for doc in plugins/compatibility/INSTALL plugins/compatibility/README; do
		dodoc ${doc}
		rm -f ${doc}
	done

	docinto admin_add
	for doc in plugins/admin_add/README; do
		dodoc ${doc}
		rm -f ${doc}
	done

	docinto retrieveuserdata
	for doc in plugins/retrieveuserdata/INSTALL plugins/retrieveuserdata/changelog plugins/retrieveuserdata/users_example.txt; do
		dodoc ${doc}
		rm -f ${doc}
	done

	if use virus-scan; then
		docinto virus-scan
		for doc in plugins/virus_scan/README; do
			dodoc ${doc}
			rm -f ${doc}
		done
	fi

	if use crypt; then
		docinto gpg
		for doc in plugins/gpg/README plugins/gpg/README.txt plugins/gpg/INSTALL plugins/gpg/INSTALL.txt plugins/gpg/TODO; do
			dodoc ${doc}
			rm -f ${doc}
		done
	fi

	if use ldap; then
		rm plugins/ldapuserdata/README
		docinto ldapuserdata
		for doc in plugins/ldapuserdata/doc/README; do
			dodoc ${doc}
			rm -f ${doc}
		done
	fi

	if use ssl; then
		docinto secure_login
		for doc in plugins/secure_login/INSTALL plugins/secure_login/README; do
			dodoc ${doc}
			rm -f ${doc}
		done

		docinto show_ssl_link
		for doc in plugins/show_ssl_link/INSTALL plugins/show_ssl_link/README; do
			dodoc ${doc}
			rm -f ${doc}
		done
	fi

	# Copy the app's main files
	einfo "Installing squirrelmail files."
	cp -r . ${D}${MY_HTDOCSDIR}

	# Identify the configuration files that this app uses
	local configs="config/config.php config/config_local.php plugins/retrieveuserdata/config.php"
	use virus-scan && configs="${configs} plugins/virus_scan/config.php"
	use crypt && configs="${configs} plugins/gpg/gpg_local_prefs.txt"
	use ldap && configs="${configs} plugins/ldapuserdata/config.php"
	use ssl && configs="${configs} plugins/show_ssl_link/config.php plugins/secure_login/config.php"

	for file in ${configs}; do
		webapp_configfile ${MY_HTDOCSDIR}/${file}
	done

	# Identify any script files that need #! headers adding to run under
	# a CGI script (such as PHP/CGI)
	#
	# for phpmyadmin, we *assume* that all .php files that don't end in
	# .inc.php need to have CGI/BIN support added

	#for x in `find . -name '*.php' -print | grep -v 'inc.php'` ; do
	#	webapp_runbycgibin php ${MY_HTDOCSDIR}/$x
	#done

	# virus scanning signatures needs to be owned by the server so it can update them
	local server_owned="data index.php"
	use virus-scan && server_owned="${server_owned} plugins/virus_scan/includes/virussignatures.php plugins/virus_scan/config.php"
	for file in ${server_owned}; do
		webapp_serverowned ${MY_HTDOCSDIR}/${file}
	done

	# add the post-installation instructions
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	# all done
	#
	# now we let the eclass strut its stuff ;-)

	webapp_src_install
}
