# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/joomla/joomla-1.0.1.ebuild,v 1.2 2005/09/29 12:16:50 rl03 Exp $

inherit webapp eutils

MY_P="${PN/j/J}_${PV}-Stable"
DESCRIPTION="Joomla is one of the most powerful Open Source Content Management
Systems on the planet."
HOMEPAGE="http://www.joomla.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
S=${WORKDIR}

IUSE=""

RDEPEND="dev-db/mysql
	virtual/php
	net-www/apache"

pkg_setup () {
	webapp_pkg_setup
	einfo "Please make sure that your PHP is compiled with XML and MySQL support"
}

src_install () {
	webapp_src_preinst
	local files="administrator/backups administrator/components
	administrator/modules administrator/templates cache components
	images images/banners images/stories language mambots mambots/content
	mambots/editors mambots/editors-xtd mambots/search
	media modules templates"

	dodoc CHANGELOG.php INSTALL.php

	cp -R . ${D}/${MY_HTDOCSDIR}

	for file in ${files}; do
		webapp_serverowned "${MY_HTDOCSDIR}/${file}"
	done

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}

pkg_postinst () {
	einfo "Now run ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo "to setup the database"
	einfo "Note that db and dbuser need to be present prior to running db setup"
	webapp_pkg_postinst
}

pkg_config() {
	# default values for db stuff
	D_DB="joomla"
	D_HOST="localhost"
	D_USER="joomla"

	# do we want to start mysqld?
	/etc/init.d/mysql restart || die "mysql needs to be running"

	echo -n "mysql db name [${D_DB}]: "; read MY_DB
	[[ -z ${MY_DB} ]] && MY_DB=${D_DB}

	echo -n "mysql db host [${D_HOST}]: "; read MY_HOST
	[[ -z ${MY_HOST} ]] && MY_HOST=${D_HOST}

	echo -n "mysql dbuser name [${D_USER}]: "; read MY_USER
	[[ -z ${MY_USER} ]] && MY_USER=${D_USER}

	echo -n "mysql dbuser password: "; read mypwd
	[[ -z ${mypwd} ]] && die "Error: no dbuser password"

	# privileges
	echo -n "Please enter login info for user who has grant privileges on ${MY_HOST} [$USER]: "; read adminuser
	[[ -z ${adminuser} ]] && adminuser="$USER"
	if [ "${MY_HOST}" != "localhost" ]; then
		echo -n "Client address (at db side) [$(hostname -f)]: "; read clientaddr
		[[ -z ${clientaddr} ]] && clientaddr="$(hostname -f)"
	fi
	# this will be default for localhost
	[[ -z ${clientaddr} ]] && clientaddr="${MY_HOST}"

	# if $MY_HOST == localhost, don't specify -h argument, so local socket can be used.
	host=${MY_HOST/localhost}
	mysqladmin -u ${adminuser} ${host:+-h ${host}} -p create ${MY_DB} || die "Error creating database"
	mysql -u "${adminuser}" "${host:+-h ${host}}" -p \
		-e "GRANT SELECT,INSERT,UPDATE,DELETE,INDEX,ALTER,CREATE,DROP,REFERENCES
		ON ${MY_DB}.* TO '${MY_USER}'@'${clientaddr}' IDENTIFIED BY '${mypwd}'; FLUSH PRIVILEGES;"  || die "Error initializing database. Please grant permissions manually."
}
