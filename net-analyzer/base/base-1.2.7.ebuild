# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/base/base-1.2.7.ebuild,v 1.1 2006/12/02 17:20:33 vanquirius Exp $

inherit webapp versionator eutils depend.apache depend.php

CONF_DIR="/etc/${PN}"
CONF_OLD="base_conf.php.dist"
CONF_NEW="base_conf.php"
MIDDLEMAN="base_path.php"

DESCRIPTION="A web-based front-end to the Snort IDS."
HOMEPAGE="http://base.secureideas.net"
SRC_URI="mirror://sourceforge/secureideas/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
# SLOT is intentionally omitted because this package uses webapp-config

DBTYPES="mssql mysql oracle postgres"
IUSE="gd ${DBTYPES}"

# BASE *should* work with any php-driven web server, so only require Apache
# when the user has an apache use-flag set.
want_apache

DEPEND=">=app-arch/tar-1.14
	>=sys-libs/zlib-1.2.1-r3
	>=app-arch/gzip-1.3.5-r4
	>=sys-apps/coreutils-5.2.1-r2
	>=sys-apps/sed-4.0.9"

RDEPEND="${DEPEND}
	>=dev-php/adodb-4.68
	gd? ( || ( >=dev-php4/jpgraph-1.19 >=dev-php5/jpgraph-2.0_beta )
		    >=dev-php/PEAR-PEAR-1.3.6-r1
		    >=dev-php/PEAR-Image_Color-1.0.2
		    >=dev-php/PEAR-Log-1.9.3
		    >=dev-php/PEAR-Numbers_Roman-0.2.0
		    >=dev-php/PEAR-Numbers_Words-0.14.0
		    >=dev-php/PEAR-Image_Canvas-0.2.4
		    >=dev-php/PEAR-Image_Graph-0.7.1
		    >=media-libs/gd-2.0.32
	mysql? ( virtual/mysql )
	postgres? ( >=dev-db/postgresql-7.1.0 ) )"
	# A local database isn't necessary, so only require one when the user
	# has use-flags set for one of the supported DBs.
	# Snort can also be installed on a remote system, so don't require it.

# Require PHP.
need_php

pkg_setup() {
	webapp_pkg_setup

	# Set the group ownership for /etc/base/base_conf.php so it can be read by
	# the user's web server.
	if use apache2 || use apache; then
		HTTPD_GROUP="apache"
	else
		# Set a safe default group.
		HTTPD_GROUP="root"
	fi

	# Check and setup selected DB type
	dbtypecnt=0
	for db in ${DBTYPES}; do
		if use ${db}; then
			if [ ${dbtypecnt} -eq 0 ]; then
				BASE_DBTYPE=${db}
				let dbtypecnt++
			elif [ ${dbtypecnt} -ge 1 ]; then
				einfo "You set multiple database types in your USE flags."
				ewarn "You will have to setup DBtype configuration manually."
			fi
		fi
	done

	if [ ${dbtypecnt} -eq 0 ]; then
		einfo "No database type selected in your USE flags."
		ewarn "You will have to setup DBtype manually."
	fi

	# Make sure php was built with the necessary USE flags.
	require_php_with_use session
	useq gd && require_gd
	useq mssql && require_php_with_use mssql
	useq mysql && require_php_with_use mysql
	useq postgres && require_php_with_use postgres
	if use oracle && ! built_with_use virtual/php oci8-instant-client ; then
		ewarn "PHP with oci8-instant-client support not found!"
		ewarn "It is your responsibility to ensure that PHP will work"
		ewarn "with commercial Oracle implementation."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Help the user configure /etc/base/base_conf.php so BASE works out of the
	# box in most environments. The user will still be warned to edit the
	# file manually at the pkg_postinst() stage.
	sed -i -e 's:$BASE_urlpath.*:$BASE_urlpath = "/base";:g' \
		${CONF_OLD}

	sed -i -e 's:$DBlib_path.*:$DBlib_path = "/usr/share/php/adodb";:g' \
			${CONF_OLD}

	if [[ "${BASE_DBTYPE}" == "postgres" ]]; then
		sed -i -e 's:$DBtype.*:$DBtype = "postgres";:g' \
			${CONF_OLD}
	fi
	if [[ "${BASE_DBTYPE}" == "mssql" ]]; then
		sed -i -e 's:$DBtype.*:$DBtype = "mssql";:g' \
			${CONF_OLD}
	fi
	if [[ "${BASE_DBTYPE}" == "oracle" ]]; then
		sed -i -e 's:$DBtype.*:$DBtype = "oci8";:g' \
			${CONF_OLD}
	fi

	# Install the configuration files in the usual /etc/${PN} location so that
	# etc-update functions properly (it also improves security somewhat, since
	# the config file contains plain-text passwords and should not be located
	# inside the web-root). This requires changing the BASE source a tad to
	# recognize the new location for base_conf.php.
	for PHP in *.php */*.php; do
		sed -i -e "s:${CONF_NEW}:${MIDDLEMAN}:g" \
			${CONF_OLD} "${PHP}"
	done

	# Create the file ${MIDDLEMAN} to determine the web-root and to change
	# the location of "include" to /etc/base/base_conf.php.
	echo "<?php" > ${MIDDLEMAN}
	echo '  $BASE_path = dirname(__FILE__);' >> ${MIDDLEMAN}
	echo "  include(\"${CONF_DIR}/${CONF_NEW}\");" >> ${MIDDLEMAN}
	echo "?>" >> ${MIDDLEMAN}

	# Delete the $BASE_path variable from the config file because we
	# now handle it with ${MIDDLEMAN} created above.
	sed -i -e 's:$BASE_path =.*::g' ${CONF_OLD}

	# Modify the HTML headers so search engines don't index BASE.
	sed -i -e \
		's:<HEAD>:<HEAD>\n  <META name="robots" content="noindex,nofollow">:g' \
			index.php
	sed -i -e \
		's:<HEAD>:<HEAD>\n  <META name="robots" content="noindex,nofollow">:g' \
			base_main.php
}

src_install() {
	webapp_src_preinst

	# Install the docs once in the standard /usr/share/doc/${PF}/DOCDESTREE
	# location instead of installing them in every virtual host directory.
	cd docs
	dodoc *
	cd "${S}"
	rm -rf docs

	# Install the config files in the normal location (/etc/${PN}).
	insinto ${CONF_DIR} || die "Unable to insinto ${CONF_DIR}"
	doins ${CONF_OLD} || die "Unable to doins ${CONF_OLD}"
	newins ${CONF_OLD} ${CONF_NEW} || die "Unable to create ${CONF_NEW}"

	# Install BASE for webapp-config
	insinto ${MY_HTDOCSDIR} || die "Unable to insinto ${MY_HTDOCSDIR}"
	doins -r *

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	# Set the proper permissions on /etc/base/base_conf.php
	chmod 640 ${CONF_DIR}/${CONF_NEW} || FPERMS="FALSE"
	chown root:${HTTPD_GROUP} ${CONF_DIR}/${CONF_NEW} || FOWNERS="FALSE"

	# Notify the user of any problems at the very end.
	if [ "${HTTPD_GROUP}" == "root" ]; then
			ewarn ""
			ewarn "It looks like you are not using Apache or Cherokee"
			ewarn "as your web server. For BASE to work properly, you will"
			ewarn "need to change the ownership of ${CONF_DIR}/${CONF_NEW} to"
			ewarn "root:[www user] To use Apache, add \"apache\" or"
			ewarn "\"apache2\" to your USE flags and re-emerge BASE."
	fi
	if [ "${FPERMS}" == "FALSE" ]; then
			ewarn ""
			ewarn "Unable to change the permissions on ${CONF_DIR}/${CONF_NEW}".
			ewarn "Please change them manually by issuing:"
			ewarn "chmod 640 ${CONF_DIR}/${CONF_NEW}"
	fi
	if [ "${FOWNERS}" == "FALSE" ]; then
			ewarn ""
			ewarn "Unable to change the group ownership of the file:"
			ewarn "${CONF_DIR}/${CONF_NEW}"
			ewarn "Please change this manually by issuing:"
			ewarn "chown root:${HTTPD_GROUP} ${CONF_DIR}/${CONF_NEW}"
	fi

	einfo ""
	einfo "You should edit \"${CONF_DIR}/${CONF_NEW}\" before using BASE."
	einfo ""
	einfo "To setup your initial database, direct your web browser to the"
	einfo "location you installed BASE/base_db_setup.php"
	einfo "You can find instructions in /usr/share/doc/${P}/README"
	einfo "There is a guide at http://gentoo-wiki.com/HOWTO_Apache2_with_BASE"
	einfo ""
}
