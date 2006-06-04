# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php5_1-sapi.eclass,v 1.26 2006/06/04 22:59:15 chtekk Exp $
#
# ########################################################################
#
# eclass/php5_1-sapi.eclass
#               Eclass for building different php5.1 SAPI instances
#
#				USE THIS ECLASS FOR THE "CONCENTRATED" PACKAGES
#
#               Based on robbat2's work on the php4 sapi eclass
#
# Author(s)		Stuart Herbert
#				<stuart@gentoo.org>
#
#				Luca Longinotti
#				<chtekk@gentoo.org>
#
# ========================================================================

CONFUTILS_MISSING_DEPS="adabas birdstep db2 dbmaker empress empress-bcs esoob frontbase hyperwave-api informix interbase msql oci8 sapdb solid sybase sybase-ct"
EBUILD_SUPPORTS_SHAREDEXT="1"

inherit flag-o-matic eutils phpconfutils libtool php-common-r1 toolchain-funcs

# set MY_PHP_P in the ebuild

# we only set these variables if we're building a copy of php which can be
# installed as a package in its own right
#
# copies of php which are compiled into other packages (e.g. php support
# for the thttpd web server) don't need these variables

if [[ "${PHP_PACKAGE}" == 1 ]] ; then
	HOMEPAGE="http://www.php.net/"
	LICENSE="PHP-3"
	SRC_URI="http://www.php.net/distributions/${MY_PHP_P}.tar.bz2"
	S="${WORKDIR}/${MY_PHP_P}"
fi

IUSE="${IUSE} adabas bcmath berkdb birdstep bzip2 calendar cdb cjk crypt ctype curl curlwrappers db2 dbase dbmaker debug doc empress empress-bcs esoob exif fastbuild frontbase fdftk filepro firebird flatfile ftp gd gd-external gdbm gmp hardenedphp hash hyperwave-api iconv imap informix inifile interbase iodbc ipv6 java-external kerberos ldap libedit mcve memlimit mhash ming msql mssql mysql mysqli ncurses nls oci8 oci8-instant-client odbc pcntl pcre pdo pdo-external pic posix postgres qdbm readline reflection recode sapdb sasl session sharedext sharedmem simplexml snmp soap sockets solid spell spl sqlite ssl sybase sybase-ct sysvipc threads tidy tokenizer truetype unicode vm-goto vm-switch wddx xml xmlreader xmlwriter xmlrpc xpm xsl yaz zip zlib"

# these USE flags should have the correct dependencies
DEPEND="${DEPEND}
	!dev-php/php
	!dev-php/php-cgi
	!dev-php/mod_php
	adabas? ( >=dev-db/unixODBC-1.8.13 )
	berkdb? ( =sys-libs/db-4* )
	birdstep? ( >=dev-db/unixODBC-1.8.13 )
	bzip2? ( app-arch/bzip2 )
	cdb? ( dev-db/cdb )
	cjk? ( !gd? ( !gd-external? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib ) ) )
	crypt? ( >=dev-libs/libmcrypt-2.4 )
	curl? ( >=net-misc/curl-7.10.5 )
	db2? ( >=dev-db/unixODBC-1.8.13 )
	dbmaker? ( >=dev-db/unixODBC-1.8.13 )
	empress? ( >=dev-db/unixODBC-1.8.13 )
	empress-bcs? ( >=dev-db/unixODBC-1.8.13 )
	esoob? ( >=dev-db/unixODBC-1.8.13 )
	exif? ( !gd? ( !gd-external? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib ) ) )
	fdftk? ( app-text/fdftk )
	firebird? ( dev-db/firebird )
	gd? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib )
	gd-external? ( media-libs/gd )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	gmp? ( >=dev-libs/gmp-4.1.2 )
	iconv? ( virtual/libiconv )
	imap? ( virtual/imap-c-client )
	iodbc? ( dev-db/libiodbc >=dev-db/unixODBC-1.8.13 )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-1.2.11 )
	libedit? ( || ( sys-freebsd/freebsd-lib dev-libs/libedit ) )
	mcve? ( >=dev-libs/openssl-0.9.7 )
	mhash? ( app-crypt/mhash )
	ming? ( media-libs/ming )
	mssql? ( dev-db/freetds )
	mysql? ( dev-db/mysql )
	mysqli? ( >=dev-db/mysql-4.1 )
	ncurses? ( sys-libs/ncurses )
	nls? ( sys-devel/gettext )
	oci8-instant-client? ( dev-db/oracle-instantclient-basic )
	odbc? ( >=dev-db/unixODBC-1.8.13 )
	postgres? ( >=dev-db/libpq-7.1 )
	qdbm? ( dev-db/qdbm )
	readline? ( sys-libs/readline )
	recode? ( app-text/recode )
	sapdb? ( >=dev-db/unixODBC-1.8.13 )
	sasl? ( dev-libs/cyrus-sasl >=net-nds/openldap-1.2.11 )
	sharedmem? ( dev-libs/mm )
	simplexml? ( >=dev-libs/libxml2-2.6.8 )
	snmp? ( >=net-analyzer/net-snmp-5.2 )
	soap? ( >=dev-libs/libxml2-2.6.8 )
	solid? ( >=dev-db/unixODBC-1.8.13 )
	spell? ( >=app-text/aspell-0.50 )
	ssl? ( >=dev-libs/openssl-0.9.7 )
	sybase? ( dev-db/freetds )
	tidy? ( app-text/htmltidy )
	truetype? ( =media-libs/freetype-2* >=media-libs/t1lib-5.0.0 !gd? ( !gd-external? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib ) ) )
	wddx? ( >=dev-libs/libxml2-2.6.8 )
	xml? ( >=dev-libs/libxml2-2.6.8 )
	xmlrpc? ( >=dev-libs/libxml2-2.6.8 virtual/libiconv )
	xmlreader? ( >=dev-libs/libxml2-2.6.8 )
	xmlwriter? ( >=dev-libs/libxml2-2.6.8 )
	xpm? ( || ( x11-libs/libXpm virtual/x11 ) >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib )
	xsl? ( dev-libs/libxslt >=dev-libs/libxml2-2.6.8 )
	zlib? ( sys-libs/zlib )
	virtual/mta"

# libswf conflicts with ming and should not
# be installed with the new PHP ebuilds
DEPEND="${DEPEND} !media-libs/libswf"

# simplistic for now
RDEPEND="${RDEPEND} ${DEPEND}"

# those are only needed at compile-time
DEPEND="${DEPEND}
		>=sys-devel/m4-1.4.3
		>=sys-devel/libtool-1.5.18
		>=sys-devel/automake-1.9.6
		sys-devel/automake-wrapper
		>=sys-devel/autoconf-2.59
		sys-devel/autoconf-wrapper"

# Additional features
#
# They are in PDEPEND because we need PHP installed first!
PDEPEND="${PDEPEND}
		doc? ( app-doc/php-docs )
		java-external? ( dev-php5/php-java-bridge )
		mcve? ( dev-php5/pecl-mcve )
		pdo-external? ( dev-php5/pecl-pdo )
		yaz? ( dev-php5/pecl-yaz )
		zip? ( dev-php5/pecl-zip )"

# ========================================================================
# php.ini Support
# ========================================================================

PHP_INI_FILE="php.ini"

# ========================================================================

EXPORT_FUNCTIONS pkg_setup src_compile src_install src_unpack pkg_postinst

# ========================================================================
# INTERNAL FUNCTIONS
# ========================================================================

php5_1-sapi_check_use_flags() {
	# Multiple USE dependencies
	phpconfutils_use_depend_any "truetype" "gd" "gd" "gd-external"
	phpconfutils_use_depend_any "cjk" "gd" "gd" "gd-external"
	phpconfutils_use_depend_any "exif" "gd" "gd" "gd-external"

	# Simple USE dependencies
	phpconfutils_use_depend_all	"xpm"				"gd"
	phpconfutils_use_depend_all	"gd"				"zlib"
	phpconfutils_use_depend_all	"simplexml"			"xml"
	phpconfutils_use_depend_all	"soap"				"xml"
	phpconfutils_use_depend_all	"wddx"				"xml"
	phpconfutils_use_depend_all	"xmlrpc"			"xml"
	phpconfutils_use_depend_all	"xmlreader"			"xml"
	phpconfutils_use_depend_all	"xmlwriter"			"xml"
	phpconfutils_use_depend_all	"xsl"				"xml"
	phpconfutils_use_depend_all "xmlrpc"			"iconv"
	phpconfutils_use_depend_all "java-external"		"session"
	phpconfutils_use_depend_all	"sasl"				"ldap"
	phpconfutils_use_depend_all	"mcve"				"ssl"
	phpconfutils_use_depend_all	"adabas"			"odbc"
	phpconfutils_use_depend_all	"birdstep"			"odbc"
	phpconfutils_use_depend_all	"dbmaker"			"odbc"
	phpconfutils_use_depend_all	"empress-bcs"		"odbc" "empress"
	phpconfutils_use_depend_all	"empress"			"odbc"
	phpconfutils_use_depend_all	"esoob"				"odbc"
	phpconfutils_use_depend_all	"db2"				"odbc"
	phpconfutils_use_depend_all	"iodbc"				"odbc"
	phpconfutils_use_depend_all	"sapdb"				"odbc"
	phpconfutils_use_depend_all	"solid"				"odbc"

	# Direct USE conflicts
	phpconfutils_use_conflict "gd" "gd-external"
	phpconfutils_use_conflict "oci8" "oci8-instant-client"
	phpconfutils_use_conflict "pdo" "pdo-external"
	phpconfutils_use_conflict "qdbm" "gdbm"
	phpconfutils_use_conflict "readline" "libedit"
	phpconfutils_use_conflict "recode" "mysql" "imap" "yaz"
	phpconfutils_use_conflict "sharedmem" "threads"
	phpconfutils_use_conflict "vm-goto" "vm-switch"

	# IMAP support
	php_check_imap

	# Mail support
	php_check_mta

	# PostgreSQL support
	php_check_pgsql

	# Oracle support
	php_check_oracle_8

	phpconfutils_warn_about_external_deps

	export PHPCONFUTILS_AUTO_USE="${PHPCONFUTILS_AUTO_USE}"
}

php5_1-sapi_set_php_ini_dir() {
	PHP_INI_DIR="/etc/php/${PHPSAPI}-php5"
	PHP_EXT_INI_DIR="${PHP_INI_DIR}/ext"
	PHP_EXT_INI_DIR_ACTIVE="${PHP_INI_DIR}/ext-active"
}

php5_1-sapi_install_ini() {
	destdir=/usr/$(get_libdir)/php5

	# get the extension dir
	PHPEXTDIR="`"${D}/${destdir}/bin/php-config" --extension-dir`"

	# work out where we are installing the ini file
	php5_1-sapi_set_php_ini_dir

	local phpinisrc=php.ini-dist

	dodir ${PHP_INI_DIR}
	insinto ${PHP_INI_DIR}
	newins ${phpinisrc} ${PHP_INI_FILE}

	dodir ${PHP_EXT_INI_DIR}
	dodir ${PHP_EXT_INI_DIR_ACTIVE}

	# Install any extensions built as shared objects
	if useq sharedext ; then
		for x in `ls "${D}/${PHPEXTDIR}/"*.so | sort` ; do
			inifilename=${x/.so/.ini}
			inifilename=`basename ${inifilename}`
			echo "extension=`basename ${x}`" >> "${D}/${PHP_EXT_INI_DIR}/${inifilename}"
			dosym "${PHP_EXT_INI_DIR}/${inifilename}" "${PHP_EXT_INI_DIR_ACTIVE}/${inifilename}"
		done
	fi
}

# ========================================================================
# EXPORTED FUNCTIONS
# ========================================================================

php5_1-sapi_pkg_setup() {
	# let's do all the USE flag testing before we do anything else
	# this way saves a lot of time
	php5_1-sapi_check_use_flags
}

php5_1-sapi_src_unpack() {
	if [[ "${PHP_PACKAGE}" == 1 ]] ; then
		unpack ${A}
	fi

	cd "${S}"

	# Change PHP branding
	PHPPR=${PR/r/}
	sed -e "s|^EXTRA_VERSION=\"\"|EXTRA_VERSION=\"-pl${PHPPR}-gentoo\"|g" -i configure.in || die "Unable to change PHP branding to -pl${PHPPR}-gentoo"

	# multilib-strict support
	if [[ -n "${MULTILIB_PATCH}" ]] && [[ -f "${WORKDIR}/${MULTILIB_PATCH}" ]] ; then
		epatch "${WORKDIR}/${MULTILIB_PATCH}"
	else
		ewarn "There is no multilib-strict patch available for this PHP release yet!"
	fi

	# Apply general PHP5 patches
	if [[ -d "${WORKDIR}/${MY_PHP_PV}/php5" ]] ; then
		EPATCH_SOURCE="${WORKDIR}/${MY_PHP_PV}/php5" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch
	fi

	# Apply version-specific PHP patches
	if [[ -d "${WORKDIR}/${MY_PHP_PV}/${MY_PHP_PV}" ]] ; then
		EPATCH_SOURCE="${WORKDIR}/${MY_PHP_PV}/${MY_PHP_PV}" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch
	fi

	# Patch PHP to show Gentoo as the server platform
	sed -e "s/PHP_UNAME=\`uname -a | xargs\`/PHP_UNAME=\`uname -s -n -r -v | xargs\`/g" -i configure.in || die "Failed to fix server platform name"

	# Disable interactive make test
	sed -e 's/'`echo "\!getenv('NO_INTERACTION')"`'/false/g' -i run-tests.php

	# Stop PHP from activating the Apache config, as we will do that ourselves
	for i in configure sapi/apache/config.m4 sapi/apache2filter/config.m4 sapi/apache2handler/config.m4 ; do
		sed -i.orig -e 's,-i -a -n php5,-i -n php5,g' ${i}
		sed -i.orig -e 's,-i -A -n php5,-i -n php5,g' ${i}
	done

	# Patch PHP to support heimdal instead of mit-krb5
	if has_version "app-crypt/heimdal" ; then
		sed -e 's|gssapi_krb5|gssapi|g' -i acinclude.m4 || die "Failed to fix heimdal libname"
		sed -e 's|PHP_ADD_LIBRARY(k5crypto, 1, $1)||g' -i acinclude.m4 || die "Failed to fix heimdal crypt library reference"
	fi

	# Patch for PostgreSQL support
	if useq postgres ; then
		sed -e 's|include/postgresql|include/postgresql include/postgresql/pgsql|g' -i ext/pgsql/config.m4 || die "Failed to fix PostgreSQL include paths"
	fi

	# Hardened-PHP support
	if useq hardenedphp ; then
		if [[ -n "${HARDENEDPHP_PATCH}" ]] && [[ -f "${DISTDIR}/${HARDENEDPHP_PATCH}" ]] ; then
			epatch "${DISTDIR}/${HARDENEDPHP_PATCH}"
		else
			ewarn "There is no Hardened-PHP patch available for this PHP release yet!"
		fi
	fi

	# fastbuild support
	if useq fastbuild ; then
		if [[ -n "${FASTBUILD_PATCH}" ]] && [[ -f "${WORKDIR}/${FASTBUILD_PATCH}" ]] ; then
			epatch "${WORKDIR}/${FASTBUILD_PATCH}"
		else
			ewarn "There is no fastbuild patch available for this PHP release yet!"
		fi
	fi

	# Fix configure scripts to correctly support Hardened-PHP
	einfo "Running aclocal"
	WANT_AUTOMAKE=1.9 aclocal --force || die "Unable to run aclocal successfully"
	einfo "Running libtoolize"
	libtoolize --copy --force || die "Unable to run libtoolize successfully"

	# Rebuild configure to make sure it's up to date
	einfo "Rebuilding configure script"
	WANT_AUTOCONF=2.5 autoreconf --force -W no-cross || die "Unable to regenerate configure script successfully"

	# Run elibtoolize
	elibtoolize

	# Just in case ;-)
	chmod 0755 configure || die "Failed to chmod configure to 0755"
}

php5_1-sapi_src_compile() {
	destdir=/usr/$(get_libdir)/php5
	php5_1-sapi_set_php_ini_dir

	cd "${S}"
	phpconfutils_init

	my_conf="${my_conf} --with-config-file-path=${PHP_INI_DIR} --with-config-file-scan-dir=${PHP_EXT_INI_DIR_ACTIVE} --without-pear"

	#								extension		USE flag		shared support?
	phpconfutils_extension_enable	"bcmath"		"bcmath"		1
	phpconfutils_extension_with		"bz2"			"bzip2"			1
	phpconfutils_extension_enable	"calendar"		"calendar"		1
	phpconfutils_extension_disable	"ctype"			"ctype"			0
	phpconfutils_extension_with		"curl"			"curl"			1
	phpconfutils_extension_with		"curlwrappers"	"curlwrappers"	1
	phpconfutils_extension_enable	"dbase"			"dbase"			1
	phpconfutils_extension_disable	"dom"			"xml"			0
	phpconfutils_extension_enable	"exif"			"exif"			1
	phpconfutils_extension_with		"fbsql"			"frontbase"		1
	phpconfutils_extension_with		"fdftk"			"fdftk"			1 "/opt/fdftk-6.0"
	phpconfutils_extension_enable	"filepro"		"filepro"		1
	phpconfutils_extension_enable	"ftp"			"ftp"			1
	phpconfutils_extension_with		"gettext"		"nls"			1
	phpconfutils_extension_with		"gmp"			"gmp"			1
	phpconfutils_extension_disable	"hash"			"hash"			0
	phpconfutils_extension_with		"hwapi"			"hyperwave-api"	1
	phpconfutils_extension_without	"iconv"			"iconv"			0
	phpconfutils_extension_with		"informix"		"informix"		1
	phpconfutils_extension_disable	"ipv6"			"ipv6"			0
	phpconfutils_extension_with		"kerberos"		"kerberos"		0 "/usr"
	phpconfutils_extension_disable	"libxml"		"xml"			0
	phpconfutils_extension_enable	"mbstring"		"unicode"		1
	phpconfutils_extension_with		"mcrypt"		"crypt"			1
	phpconfutils_extension_enable	"memory-limit"	"memlimit"		0
	phpconfutils_extension_with		"mhash"			"mhash"			1
	phpconfutils_extension_with		"ming"			"ming"			1
	phpconfutils_extension_with		"msql"			"msql"			1
	phpconfutils_extension_with		"mssql"			"mssql"			1
	phpconfutils_extension_with		"ncurses"		"ncurses"		1
	phpconfutils_extension_with		"openssl"		"ssl"			0
	phpconfutils_extension_with		"openssl-dir"	"ssl"			0 "/usr"
	phpconfutils_extension_enable	"pcntl" 		"pcntl" 		1
	phpconfutils_extension_without	"pcre-regex"	"pcre"			0
	phpconfutils_extension_disable	"pdo"			"pdo"			1
	phpconfutils_extension_with		"pgsql"			"postgres"		1
	phpconfutils_extension_disable	"posix"			"posix"			1
	phpconfutils_extension_with		"pspell"		"spell"			1
	phpconfutils_extension_with		"recode"		"recode"		1
	phpconfutils_extension_disable	"reflection"	"reflection"	0
	phpconfutils_extension_disable	"simplexml"		"simplexml"		1
	phpconfutils_extension_enable	"shmop"			"sharedmem"		0
	phpconfutils_extension_with		"snmp"			"snmp"			1
	phpconfutils_extension_enable	"soap"			"soap"			1
	phpconfutils_extension_enable	"sockets"		"sockets"		1
	phpconfutils_extension_disable	"spl"			"spl"			1
	phpconfutils_extension_with		"sybase"		"sybase"		1
	phpconfutils_extension_with		"sybase-ct"		"sybase-ct"		1
	phpconfutils_extension_enable	"sysvmsg"		"sysvipc"		1
	phpconfutils_extension_enable	"sysvsem"		"sysvipc"		1
	phpconfutils_extension_enable	"sysvshm"		"sysvipc"		1
	phpconfutils_extension_with		"tidy"			"tidy"			1
	phpconfutils_extension_disable	"tokenizer"		"tokenizer"		1
	phpconfutils_extension_enable	"wddx"			"wddx"			1
	phpconfutils_extension_disable	"xml"			"xml"			0
	phpconfutils_extension_disable	"xmlreader"		"xmlreader"		1
	phpconfutils_extension_disable	"xmlwriter"		"xmlwriter"		1
	phpconfutils_extension_with		"xmlrpc"		"xmlrpc"		1
	phpconfutils_extension_with		"xsl"			"xsl"			1
	phpconfutils_extension_with		"zlib"			"zlib"			1
	phpconfutils_extension_enable	"debug"			"debug"			0

	# DBA support
	if useq cdb || useq berkdb || useq flatfile || useq gdbm || useq inifile || useq qdbm ; then
		my_conf="${my_conf} --enable-dba${shared}"
	fi

	# DBA drivers support
	phpconfutils_extension_with "cdb"		"cdb"		1
	phpconfutils_extension_with "db4"		"berkdb"	1
	phpconfutils_extension_with "flatfile"	"flatfile"	1
	phpconfutils_extension_with "gdbm"		"gdbm"		1
	phpconfutils_extension_with "inifile"	"inifile"	1
	phpconfutils_extension_with "qdbm"		"qdbm"		1

	# Support for the GD graphics library
	if useq gd-external || phpconfutils_usecheck gd-external ; then
		phpconfutils_extension_with		"freetype-dir"	"truetype"		0 "/usr"
		phpconfutils_extension_with		"t1lib"			"truetype"		0 "/usr"
		phpconfutils_extension_enable	"gd-jis-conv"	"cjk" 			0
		phpconfutils_extension_enable	"gd-native-ttf"	"truetype"		0
		phpconfutils_extension_with 	"gd" 			"gd-external"	1 "/usr"
	else
		phpconfutils_extension_with		"freetype-dir"	"truetype"		0 "/usr"
		phpconfutils_extension_with		"t1lib"			"truetype"		0 "/usr"
		phpconfutils_extension_enable	"gd-jis-conv"	"cjk"			0
		phpconfutils_extension_enable	"gd-native-ttf"	"truetype"		0
		phpconfutils_extension_with		"jpeg-dir"		"gd"			0 "/usr"
		phpconfutils_extension_with 	"png-dir" 		"gd" 			0 "/usr"
		phpconfutils_extension_with 	"xpm-dir" 		"xpm" 			0 "/usr/X11R6"
		# enable gd last, so configure can pick up the previous settings
		phpconfutils_extension_with 	"gd" 			"gd" 			0
	fi

	# IMAP support
	if useq imap || phpconfutils_usecheck imap ; then
		phpconfutils_extension_with		"imap"			"imap"			1
		phpconfutils_extension_with		"imap-ssl"		"ssl"			0
	fi

	# Interbase support
	if useq firebird || useq interbase ; then
		my_conf="${my_conf} --with-interbase=/usr"
	fi

	# LDAP support
	if useq ldap || phpconfutils_usecheck ldap ; then
		phpconfutils_extension_with		"ldap"			"ldap"			1
		phpconfutils_extension_with		"ldap-sasl"		"sasl"			0
	fi

	# MySQL support
	if useq mysql ; then
		phpconfutils_extension_with		"mysql"			"mysql"			1 "/usr/lib/mysql"
		phpconfutils_extension_with		"mysql-sock"	"mysql"			0 "/var/run/mysqld/mysqld.sock"
	fi

	# MySQLi support
	phpconfutils_extension_with			"mysqli"		"mysqli"		1 "/usr/bin/mysql_config"

	# ODBC support
	if useq odbc || phpconfutils_usecheck odbc ; then
		phpconfutils_extension_with		"unixODBC"		"odbc"			1 "/usr"

		phpconfutils_extension_with		"adabas"		"adabas"		1
		phpconfutils_extension_with		"birdstep"		"birdstep"		1
		phpconfutils_extension_with		"dbmaker"		"dbmaker"		1
		phpconfutils_extension_with		"empress"		"empress"		1
		if useq empress || phpconfutils_usecheck empress ; then
			phpconfutils_extension_with	"empress-bcs"	"empress-bcs"	0
		fi
		phpconfutils_extension_with		"esoob"			"esoob"			1
		phpconfutils_extension_with		"ibm-db2"		"db2"			1
		phpconfutils_extension_with		"iodbc"			"iodbc"			1 "/usr"
		phpconfutils_extension_with		"sapdb"			"sapdb"			1
		phpconfutils_extension_with		"solid"			"solid"			1
	fi

	# Oracle support
	if useq oci8 ; then
		phpconfutils_extension_with		"oci8"			"oci8"			1
	fi
	if useq oci8-instant-client ; then
		OCI8IC_PKG="`best_version dev-db/oracle-instantclient-basic`"
		OCI8IC_PKG="`printf ${OCI8IC_PKG} | sed -e 's|dev-db/oracle-instantclient-basic-||g' | sed -e 's|-r.*||g'`"
		phpconfutils_extension_with		"oci8"			"oci8-instant-client"	1	"instantclient,/usr/lib/oracle/${OCI8IC_PKG}/client/lib"
	fi

	# PDO support
	if useq pdo || phpconfutils_usecheck pdo ; then
		phpconfutils_extension_with		"pdo-dblib"		"mssql"			1
		phpconfutils_extension_with		"pdo-firebird"	"firebird"		1
		phpconfutils_extension_with		"pdo-mysql"		"mysql"			1 "/usr"
		if useq oci8 ; then
			phpconfutils_extension_with	"pdo-oci"		"oci8"			1
		fi
		if useq oci8-instant-client ; then
			OCI8IC_PKG="`best_version dev-db/oracle-instantclient-basic`"
			OCI8IC_PKG="`printf ${OCI8IC_PKG} | sed -e 's|dev-db/oracle-instantclient-basic-||g' | sed -e 's|-r.*||g'`"
			phpconfutils_extension_with	"pdo-oci"		"oci8-instant-client"	1	"instantclient,/usr,${OCI8IC_PKG}"
		fi
		phpconfutils_extension_with		"pdo-odbc"		"odbc"			1 "unixODBC,/usr"
		phpconfutils_extension_with		"pdo-pgsql"		"postgres"		1
		phpconfutils_extension_without	"pdo-sqlite"	"sqlite"		1
	fi

	# readline/libedit support
	# You can use readline or libedit, but you can't use both
	phpconfutils_extension_with			"readline"		"readline"		0
	phpconfutils_extension_with			"libedit"		"libedit"		0

	# Session support
	if ! useq session && ! phpconfutils_usecheck session ; then
		phpconfutils_extension_disable	"session"		"session"		1
	else
		phpconfutils_extension_with		"mm"			"sharedmem"		0
	fi

	# Sqlite support
	if ! useq sqlite && ! phpconfutils_usecheck sqlite ; then
		phpconfutils_extension_without	"sqlite"		"sqlite"		0
	else
		phpconfutils_extension_enable	"sqlite-utf8"	"unicode"		0
	fi

	# Zend-GOTO-VM support
	if useq vm-goto ; then
		my_conf="${my_conf} --with-zend-vm=GOTO"
	fi

	# Zend-SWITCH-VM support
	if useq vm-switch ; then
		my_conf="${my_conf} --with-zend-vm=SWITCH"
	fi

	# Fix ELF-related problems
	if useq pic ; then
		einfo "Enabling PIC support"
		my_conf="${my_conf} --with-pic"
	fi

	# apache2 & threads support
	if useq apache2 && useq threads ; then
		my_conf="${my_conf} --enable-maintainer-zts"
		ewarn "Enabling ZTS for Apache2 MPM"
	fi

	# Catch CFLAGS problems
	php_check_cflags

	# multilib support
	if [[ $(get_libdir) != lib ]] ; then
		my_conf="--with-libdir=$(get_libdir) ${my_conf}"
	fi

	# Support user-passed configuration parameters
	[[ -z "${EXTRA_ECONF}" ]] && EXTRA_ECONF=""

	# Set the correct compiler for cross-compilation
	tc-export CC

	# We don't use econf, because we need to override all of its settings
	./configure --prefix=${destdir} --sysconfdir=/etc --cache-file=./config.cache ${my_conf} ${EXTRA_ECONF} || die "configure failed"
	emake || die "make failed"
}

php5_1-sapi_src_install() {
	destdir=/usr/$(get_libdir)/php5

	cd "${S}"
	addpredict /usr/share/snmp/mibs/.index

	PHP_INSTALLTARGETS="install-build install-headers install-programs"
	useq sharedext && PHP_INSTALLTARGETS="${PHP_INSTALLTARGETS} install-modules"
	make INSTALL_ROOT="${D}" ${PHP_INSTALLTARGETS} || die "install failed"

	# Install missing header files
	if useq unicode || phpconfutils_usecheck unicode ; then
		dodir ${destdir}/include/php/ext/mbstring/libmbfl/mbfl
		insinto ${destdir}/include/php/ext/mbstring/libmbfl/mbfl
		for x in mbfilter.h mbfl_consts.h mbfl_encoding.h mbfl_language.h mbfl_string.h mbfl_convert.h mbfl_ident.h mbfl_memory_device.h mbfl_allocators.h mbfl_defs.h mbfl_filter_output.h mbfilter_pass.h mbfilter_wchar.h mbfilter_8bit.h ; do
			doins ext/mbstring/libmbfl/mbfl/${x}
		done
	fi

	# Get the extension dir
	PHPEXTDIR="`"${D}/${destdir}/bin/php-config" --extension-dir`"

	# Don't forget the php.ini file
	local phpinisrc=php.ini-dist
	einfo "Setting extension_dir in php.ini"
	sed -e "s|^extension_dir .*$|extension_dir = ${PHPEXTDIR}|g" -i ${phpinisrc}

	# A patch for PHP for security
	einfo "Securing fopen wrappers"
	sed -e 's|^allow_url_fopen .*|allow_url_fopen = Off|g' -i ${phpinisrc}

	# Set the include path to point to where we want to find PEAR packages
	einfo "Setting correct include_path"
	sed -e 's|^;include_path = ".:/php/includes".*|include_path = ".:/usr/share/php5:/usr/share/php"|' -i ${phpinisrc}

	# Generate the USE file for PHP
	phpconfutils_generate_usefile

	# Create the directory where we'll put php5-only php scripts
	keepdir /usr/share/php5
}

php5_1-sapi_pkg_postinst() {
	# Update Apache1 to use mod_php
	if useq apache ; then
		"${ROOT}/usr/sbin/php-select" -t apache1 php5 > /dev/null 2>&1
		exitStatus=$?
		if [[ ${exitStatus} == 2 ]] ; then
			php-select apache1 php5
		elif [[ ${exitStatus} == 4 ]] ; then
			ewarn
			ewarn "Apache 1 is configured to load a different version of PHP."
			ewarn "To make Apache 1 use PHP v5, use php-select:"
			ewarn
			ewarn "   php-select apache1 php5"
			ewarn
		fi
	fi

	# Update Apache2 to use mod_php
	if useq apache2 ; then
		"${ROOT}/usr/sbin/php-select" -t apache2 php5 > /dev/null 2>&1
		exitStatus=$?
		if [[ ${exitStatus} == 2 ]] ; then
			php-select apache2 php5
		elif [[ ${exitStatus} == 4 ]] ; then
			ewarn
			ewarn "Apache 2 is configured to load a different version of PHP."
			ewarn "To make Apache 2 use PHP v5, use php-select:"
			ewarn
			ewarn "   php-select apache2 php5"
			ewarn
		fi
	fi

	# Create the symlinks for php-cli
	if useq cli || phpconfutils_usecheck cli ; then
		"${ROOT}/usr/sbin/php-select" -t php php5 > /dev/null 2>&1
		exitStatus=$?
		if [[ ${exitStatus} == 5 ]] ; then
			php-select php php5
		elif [[ ${exitStatus} == 4 ]] ; then
			ewarn
			ewarn "/usr/bin/php links to a different version of PHP."
			ewarn "To make /usr/bin/php point to PHP v5, use php-select:"
			ewarn
			ewarn "   php-select php php5"
			ewarn
		fi
	fi

	# Create the symlinks for php-cgi
	if useq cgi ; then
		"${ROOT}/usr/sbin/php-select" -t php-cgi php5 > /dev/null 2>&1
		exitStatus=$?
		if [[ ${exitStatus} == 5 ]] ; then
			php-select php-cgi php5
		elif [[ ${exitStatus} == 4 ]] ; then
			ewarn
			ewarn "/usr/bin/php-cgi links to a different version of PHP."
			ewarn "To make /usr/bin/php-cgi point to PHP v5, use php-select:"
			ewarn
			ewarn "   php-select php-cgi php5"
			ewarn
		fi
	fi

	# Create the symlinks for php-devel
	"${ROOT}/usr/sbin/php-select" -t php-devel php5 > /dev/null 2>&1
	exitStatus=$?
	if [[ $exitStatus == 5 ]] ; then
		php-select php-devel php5
	elif [[ $exitStatus == 4 ]] ; then
		ewarn
		ewarn "/usr/bin/php-config and/or /usr/bin/phpize are linked to a"
		ewarn "different version of PHP. To make them point to PHP v5, use"
		ewarn "php-select:"
		ewarn
		ewarn "   php-select php-devel php5"
		ewarn
	fi

	ewarn "If you have additional third party PHP extensions (such as"
	ewarn "dev-php5/phpdbg) you may need to recompile them now."
	ewarn "A new way of enabling/disabling PHP extensions was introduced"
	ewarn "with the newer PHP packages releases, so please reemerge any"
	ewarn "PHP extensions you have installed to automatically adapt to"
	ewarn "the new configuration layout."
	if useq sharedext ; then
		ewarn "The core PHP extensions are now loaded through external"
		ewarn ".ini files, not anymore using a 'extension=name.so' line"
		ewarn "in the php.ini file. Portage will take care of this by"
		ewarn "creating new, updated config-files, please make sure to"
		ewarn "install those using etc-update or dispatch-conf."
	fi
	ewarn

	if useq curl; then
		ewarn "Please be aware that CURL can allow the bypass of open_basedir restrictions."
		ewarn "This can be a security risk!"
		ewarn
	fi

	ewarn "The 'pic' USE flag was added to newer releases of dev-lang/php."
	ewarn "With PIC enabled, your PHP installation may become slower, but"
	ewarn "PIC is required on Hardened-Gentoo platforms (where the USE flag"
	ewarn "is enabled automatically). You may also need this on other"
	ewarn "configurations where you disabled TEXTRELs, for example using"
	ewarn "PaX in the kernel."
	ewarn

	ewarn "With PHP 5.1, some extensions were removed from PHP because"
	ewarn "they were unmaintained or moved to PECL. Our ebuilds reflect"
	ewarn "this: the Oracle extension was removed ('oracle7' USE flag),"
	ewarn "please use the 'oci8' USE flag for Oracle support now and/or"
	ewarn "the PDO OCI8 driver, enabled if you set both the 'oci8' and"
	ewarn "'pdo' USE flags. Also, the MCVE extension was moved to PECL"
	ewarn "and thus can now be found in dev-php5/pecl-mcve. The Ovrimos"
	ewarn "and Pfpro extensions were removed altogether and have no"
	ewarn "available substitute."

	ewarn "The 'xml' and 'xml2' USE flags were unified in only the 'xml' USE"
	ewarn "flag. To get the features that were once controlled by the 'xml2'"
	ewarn "USE flag, turn the 'xml' USE flag on."
	ewarn
}
