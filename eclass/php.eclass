# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author: Robin H. Johnson <robbat2@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/php.eclass,v 1.67 2003/07/19 03:11:05 robbat2 Exp $

# This EBUILD is totally masked presently. Use it at your own risk.  I know it
# is severely broken, but I needed to get a copy into CVS to pass around and
# repoman was complaining at me too much

# TODO LIST
# * Finish install cleanup
# * USE flags
#sys-libs/ncurses
#--with-ncurses

inherit eutils flag-o-matic

ECLASS=php
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_preinst

function runningunstable() { has ~${ARCH} ${ACCEPT_KEYWORDS} > /dev/null ; }

[ -z "${MY_PN}" ] && MY_PN=php
[ -z "${MY_P}" ] && MY_P=${MY_PN}-${PV}
[ -z "${HOMEPAGE}" ]	&& HOMEPAGE="http://www.php.net/"
[ -z "${LICENSE}" ]	&& LICENSE="PHP"
[ -z "${PROVIDE}" ]	&& PROVIDE="virtual/php"
# PHP.net does automatic mirroring from this URI
if [ -z "${SRC_URI}" ]; then
	SRC_URI="http://www.php.net/distributions/${MY_P}.tar.bz2"
	#Remove the DB4 stuff temporarily
	#mirror://gentoo/${MY_P}-db4.diff.gz 
fi

# Where we work
S=${WORKDIR}/${MY_P}

IUSE="${IUSE} X cjk crypt curl firebird flash freetds gd gd-external gdbm imap informix ipv6 java jpeg ldap mcal memlimit mysql nls oci8 odbc pam pdflib png postgres qt snmp spell ssl tiff truetype xml2"

# Berkdb is disabled due to DB4 and changes in PHP4.3.2
#RDEPEND="${RDEPEND} berkdb? ( >=sys-libs/db-4.1.25 )"
#IUSE="${IUSE} berkdb"

# Everything is in this list is dynamically linked agaist or needed at runtime in some other way
RDEPEND="
	>=sys-libs/cracklib-2.7-r7
	sys-apps/bzip2
	X? ( virtual/x11 )
	crypt? ( >=dev-libs/libmcrypt-2.4 >=app-crypt/mhash-0.8 )
	curl? ( >=net-ftp/curl-7.10.2 )
	firebird? ( >=dev-db/firebird-1.0 )
	freetds? ( >=dev-db/freetds-0.53 )
	gd-external? ( media-libs/libgd >=media-libs/jpeg-6b >=media-libs/libpng-1.2.5 )
	gd? ( >=media-libs/jpeg-6b >=media-libs/libpng-1.2.5 )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	java? ( =virtual/jdk-1.4* dev-java/java-config )
	jpeg? ( >=media-libs/jpeg-6b )
	ldap? ( >=net-nds/openldap-1.2.11 )
	mysql? ( >=dev-db/mysql-3.23.26 )
	nls? ( sys-devel/gettext )
	odbc? ( >=dev-db/unixODBC-1.8.13 )
	pam? ( >=sys-libs/pam-0.75 )
	pdflib? ( >=media-libs/pdflib-4.0.3 >=media-libs/jpeg-6b >=media-libs/libpng-1.2.5 >=media-libs/tiff-3.5.5 )
	png? ( >=media-libs/libpng-1.2.5 )
	postgres? ( >=dev-db/postgresql-7.1 )
	qt? ( >=x11-libs/qt-2.3.0 )
	snmp? ( net-analyzer/net-snmp )
	spell? ( app-text/aspell )
	ssl? ( >=dev-libs/openssl-0.9.5 )
	tiff? ( >=media-libs/tiff-3.5.5 )
	xml2? ( dev-libs/libxml2 >=dev-libs/libxslt-1.0.30 )
	>=net-libs/libwww-5.3.2
	>=app-text/sablotron-0.97
	dev-libs/expat
	sys-libs/zlib 
	virtual/mta"

# libswf is ONLY available on x86
RDEPEND="${RDEPEND}
	flash? ( x86? ( media-libs/libswf ) >=media-libs/ming-0.2a )"
	
	
	# Testing per bug #13382
if runningunstable; then
	RDEPEND="${RDEPEND}
		truetype? ( >=media-libs/freetype-2 )"
else
	RDEPEND="${RDEPEND}
		truetype? ( ~media-libs/freetype-1.3.1 >=media-libs/t1lib-1.3.1 )"
fi

# These are extra bits we need only at compile time
DEPEND="${RDEPEND} ${DEPEND}
	imap? ( virtual/imap-c-client )
	mcal? ( dev-libs/libmcal )"
#9libs causes a configure error
DEPEND="${DEPEND} !dev-libs/9libs"
#dev-libs/libiconv causes a compile failure
DEPEND="${DEPEND} !dev-libs/libiconv"


#Waiting for somebody to want this:
#cyrus? ( net-mail/cyrus-imapd net-mail/cyrus-imap-admin dev-libs/cyrus-imap-dev ) 

#export this here so we can use it
myconf="${myconf}"

## PHP offers a wide range of Server APIs (SAPIs)
#[ -z "${PHP_SAPI}" ] && die "Your ebuild must specify a PHP SAPI to build with!"
#local php_sapi_supported
#php_sapi_supported=0
#case ${PHP_SAPI} in
#cgi) php_sapi_supported=1 ; PHP_CGI=1 ;;
#cli) php_sapi_supported=1 ; PHP_CLI=1 ;;
#apxs) php_sapi_supported=1 ;;
#apxs2) php_sapi_supported=1 ;;
#apache) ;;
#aolserver) ;;
#mod_charset) ;;
#caudium) ;;
#isapi) ;;
#nsapi) ;;
#phttpd) ;;
#pi3web) ;;
#roxen) ;;
#servlet) ;;
#thttpd) ;;
#tux) ;;
#esac
#
## be nice to other developers ;-)
#if [ "${php_sapi_supported}" -ne "1" ]; then 
#	ewarn "Your SAPI choice is NOT offically supported in php.eclass yet."
#	ewarn "Please contact php-bugs for any issues."
#fi

# These are the standard targets that we want to for the install stage since we can't do the full 'make install'
# You may need to add your own items here for SAPIs etc.
PHP_INSTALLTARGETS="${PHP_INSTALLTARGETS} install-modules install-pear install-build install-headers install-programs"
#overall recommended order
#install-cli install-sapi install-modules install-pear install-build install-headers install-programs

PHPMAJORVER=${PV//\.*}

# These are quick fixups for older ebuilds that didn't have PHPSAPI defined.
[ -z "${PHPSAPI}" ] && [ "${PN}" -eq "php" ] && PHPSAPI="cli"
if [ -z "${PHPSAPI}" ] && [ "${PN}" -eq "mod_php" ]; then
	use apache2 && PHPSAPI="apache2" || PHPSAPI="apache1"
fi

# Now enforce existance of PHPSAPI
if [ -z "${PHPSAPI}" ]; then
	msg="The PHP eclass needs a PHPSAPI setting!"
	eerror "${msg}"
	die "${msg}"
fi
PHPINIDIRECTORY="/etc/php/${PHPSAPI}-php${PHPMAJORVER}"
PHPINIFILENAME="php.ini"

#fixes bug #14067
replace-flags "-march=k6*" "-march=i586"

php_check_java_config() {
	JDKHOME="`java-config --jdk-home`"
	NOJDKERROR="You need to use java-config to set your JVM to a JDK!"
	if [ -z "${JDKHOME}" ] || [ ! -d "${JDKHOME}" ]; then
		eerror "${NOJDKERROR}"
		die "${NOJDKERROR}"
	fi

	# stuart@gentoo.org - 2003/05/18
	# Kaffe JVM is not a drop-in replacement for the Sun JDK at this time

	if echo $JDKHOME | grep kaffe > /dev/null 2>&1 ; then
		eerror
		eerror "PHP will not build using the Kaffe Java Virtual Machine."
		eerror "Please change your JVM to either Blackdown or Sun's."
		eerror 
		eerror "To build PHP without Java support, please re-run this emerge"
		eerror "and place the line:"
		eerror "  USE='-java'"
		eerror "in front of your emerge command; e.g."
		eerror "  USE='-java' emerge mod_php"
		eerror
		eerror "or edit your USE flags in /etc/make.conf"
		die
	fi
}

php_src_unpack() {
	use xml || \
	( ewarn "You have the xml USE flag turned off. Previously this"
	  ewarn "disabled XML support in PHP. However PEAR has a hard"
	  ewarn "dependancy on it, so they are now enabled." )

	unpack ${MY_P}.tar.bz2
	cd ${S}

	# Configure Patch for wired uname -a
	mv configure configure.old
	cat configure.old | sed "s/PHP_UNAME=\`uname -a\`/PHP_UNAME=\`uname -s -n -r -v\`/g" > configure
	chmod 755 configure

	# fix PEAR installer
	cp pear/PEAR/Registry.php pear/PEAR/Registry.old
	sed "s:\$pear_install_dir\.:\'$D/usr/lib/php/\' . :g" pear/PEAR/Registry.old > pear/PEAR/Registry.php
}


php_src_compile() {
	# Stuart, test this (just uncomment it):
	# use ldap && use kerberos && LIBS="${LIBS} -lkrb4"
	
	# Control the extra SAPI stuff that can be built in addition to any usual SAPI
#	[ -z "${PHP_CGI}" ] && PHP_CGI=0
#	[ -z "${PHP_CLI}" ] && PHP_CLI=0
#	[ -z "${PHP_EMBED}" ] && PHP_EMBED=no
#	[ "${PHP_CGI}" -eq "0" ] \
#		&& myconf="${myconf} --disable-cgi" \
#		|| myconf="${myconf} --enable-cgi --enable-fastcgi" 
#	[ "${PHP_CLI}" -eq "0" ] \
#		&& myconf="${myconf} --disable-cli" \
#		|| myconf="${myconf} --enable-cli" 
#	case "${PHP_EMBED}" in
#		shared) myconf="${myconf} --enable-embed=shared" ;;
#		static) myconf="${myconf} --enable-embed=static" ;;
#		*) myconf="${myconf} --disable-embed" ;;
#	esac;

	[ -x "/usr/sbin/sendmail" ] || die "You need a virtual/mta that provides /usr/sbin/sendmail!"

	use java && php_check_java_config

	# BerkDB is disabled due to DB4 and changes in PHP4.3.2
	myconf="${myconf} --without-db3 --without-db4 --without-db2"
	if use berkdb; then
		ewarn "BerkDB is disabled due to DB4 issues and changes in PHP 4.3.2 presently."
		ewarn "If you need BerkDB support, please do NOT upgrade at this time"
	#	#Hack to use db4
	#	if has_version =sys-libs/db-4* && grep -q -- '--with-db4' configure; then
	#		einfo "Enabling DB4"
	#		myconf="${myconf} --with-db4=/usr"
	#	else
	#		einfo "Enabling DB3"
	#		myconf="${myconf} --with-db3=/usr"
	#	fi
	fi

	use crypt && myconf="${myconf} --with-mcrypt=/usr --with-mhash"
	use firebird && myconf="${myconf} --with-interbase=/opt/interbase"
	use flash && myconf="${myconf} --with-ming=/usr"
	use flash && use x86 && myconf="${myconf} --with-swf=/usr"
	use freetds && myconf="${myconf} --with-sybase=/usr"
	use gdbm && myconf="${myconf} --with-gdbm=/usr"
	use informix && [ -n "${INFORMIXDIR}" ] && myconf="${myconf} --with-informix=${INFORMIXDIR}"
	use java && myconf="${myconf} --with-java=${JAVA_HOME}"
	use mcal && myconf="${myconf} --with-mcal=/usr"
	use oci8 && [ -n "${ORACLE_HOME}" ] && myconf="${myconf} --with-oci8=${ORACLE_HOME}"
	use odbc && myconf="${myconf} --with-unixODBC=/usr"
	use postgres && myconf="${myconf} --with-pgsql=/usr" || myconf="${myconf} --without-pgsql"
	use snmp && myconf="${myconf} --with-snmp --enable-ucd-snmp-hack"
	use X && myconf="${myconf} --with-xpm-dir=/usr/X11R6" LDFLAGS="${LDFLAGS} -L/usr/X11R6/lib"
	
	# This chunk is intended for png/tiff/jpg, as there are several things that need them, indepentandly!
	REQUIREPNG=
	REQUIREJPG=
	REQUIRETIFF=
	use pdflib && myconf="${myconf} --with-pdflib=/usr" 
	use pdflib && REQUIREPNG=1 REQUIREJPG=1 REQUIRETIFF=1
	if [ -n "`use gd-external`" ] ; then
		myconf="${myconf} --with-gd=/usr"
		REQUIREPNG=1
	elif [ -n "`use gd`" ] ; then
		myconf="${myconf} --with-gd"
		REQUIREPNG=1
		REQUIREJPG=1
	else
		myconf="${myconf} --without-gd"
	fi
	use png || [ -n "${REQUIREPNG}" ] && myconf="${myconf} --with-png-dir=/usr" || myconf="${myconf} --without-png"
	use jpeg || [ -n "${REQUIREJPG}" ] && myconf="${myconf} --with-jpeg --with-jpeg-dir=/usr --enable-exif" myconf="${myconf} --without-jpeg" 
	use tiff || [ -n "${REQUIRETIFF}" ] && myconf="${myconf} --with-tiff-dir=/usr" LDFLAGS="${LDFLAGS} -ltiff" || myconf="${myconf} --without-tiff"

	#use mysql && myconf="${myconf} --with-mysql=/usr" || myconf="${myconf} --without-mysql"
	if use mysql; then
		if [ -n "`mysql_config | grep '4.1'`" ] ; then
			myconf="${myconf} --with-mysqli=/usr"
		else
			myconf="${myconf} --with-mysql=/usr"
			myconf="${myconf} --with-mysql-sock=`mysql_config --socket`"
		fi
	else
		myconf="${myconf} --without-mysql"
	fi

	# Testing per bug #13382
	if runningunstable; then
		use truetype && myconf="${myconf} --with-freetype-dir=/usr"
	else
		myconf="${myconf} `use_with truetype ttf` `use_with truetype t1lib`"
	fi

	myconf="${myconf} `use_with nls gettext` `use_with qt qtdom`"
	myconf="${myconf} `use_with spell pspell` `use_with ssl openssl`"
	myconf="${myconf} `use_with curl` `use_with imap` `use_with ldap`"
	myconf="${myconf} `use_with xml2 dom` `use_with xml2 dom-xslt`"
	myconf="${myconf} `use_with kerberos` `use_with pam`"
	myconf="${myconf} `use_enable memlimit memory-limit`"
	myconf="${myconf} `use_enable cjk mbstring` `use_enable cjk mbregex`"
	myconf="${myconf} `use_enable ipv6`"

	#Waiting for somebody to want Cyrus support :-)
	#myconf="${myconf} `use_with cyrus`"

	# dbx AT LEAST one of mysql/odbc/postgres/oci8
	use mysql || use odbc || use postgres || use oci8 \
		&& myconf="${myconf} --enable-dbx" \
		|| myconf="${myconf} --disable-dbx"

	use imap && use ssl && \
	if [ -n "`strings ${ROOT}/usr/lib/c-client.a 2>/dev/null | grep ssl_onceonlyinit`" ]; then
		myconf="${myconf} --with-imap-ssl"
		einfo "Building IMAP with SSL support."
	else
		ewarn "USE=\"imap ssl\" specified but IMAP is built WITHOUT ssl support."
		ewarn "Skipping IMAP-SSL support."
	fi

	
	# These were previously optional, but are now included directly as PEAR needs them.
	# Zlib is needed for XML
	myconf="${myconf} --with-zlib --with-zlib-dir=/usr/lib"
	LIBS="${LIBS} -lxmlparse -lxmltok"
	myconf="${myconf} --with-sablot=/usr"
	myconf="${myconf} --enable-xslt" 
	myconf="${myconf} --with-xslt-sablot" 
	myconf="${myconf} --with-xmlrpc"
	myconf="${myconf} --enable-wddx"
	myconf="${myconf} --with-xml"

	# Somebody might want safe mode, but it causes some problems, so I disable it by default
	#myconf="${myconf} --enable-safe-mode"

	# These are some things that we don't really need use flags for, we just
	# throw them in for functionality. Somebody could turn them off if their
	# heart so desired
	# DEPEND sys-apps/bzip2
	myconf="${myconf} --with-bz2"
	# DEPEND sys-libs/cracklib
	myconf="${myconf} --with-crack"
	# DEPEND sys-libs/db 
	myconf="${myconf} --with-ndbm --with-cdb"
	
	# No DEPENDancies
	mycony="${myconf} --enable-pcntl"
	myconf="${myconf} --enable-bcmath"
	myconf="${myconf} --enable-calendar"
	myconf="${myconf} --enable-dbase"
	myconf="${myconf} --enable-filepro"
	myconf="${myconf} --enable-ftp"
	myconf="${myconf} --with-mime-magic"
	myconf="${myconf} --enable-sockets"
	myconf="${myconf} --enable-sysvsem --enable-sysvshm --enable-sysvipc"
	myconf="${myconf} --with-iconv"
	myconf="${myconf} --enable-shmop"
	myconf="${myconf} --enable-dio"

	# recode is NOT used as it conflicts with IMAP and YAZ
	# iconv is better anyway

	# Now actual base PHP settings
	myconf="${myconf} \
		--enable-inline-optimization \
		--enable-track-vars \
		--enable-trans-sid \
		--enable-versioning \
		--with-config-file-path=${PHPINIDIRECTORY}" 

	LIBS="${LIBS}" econf \
		${myconf} || die "bad ./configure"
	
	emake || die "compile problem"

}

php_src_install() {
	addwrite /usr/share/snmp/mibs/.index
	dodir /usr/bin
	dodir /usr/lib/php
	dodir /usr/include/php

	# parallel make breaks it
	# so no emake here
	make INSTALL_ROOT=${D} ${PHP_INSTALLTARGETS} || die
	PHPEXTDIR="`${D}/usr/bin/php-config  --extension-dir`"
	
	# put make here

	dodoc LICENSE EXTENSIONS CREDITS INSTALL
	dodoc README.* TODO* NEWS

	#install scripts
	exeinto /usr/bin

	# PHP module building stuff
	mkdir -p ${D}/usr/lib/php/build
	insinto /usr/lib/php/build
	doins build/* acinclude.m4 configure.in Makefile.global scan_makefile_in.awk
	# Deprecated : pear/pear.m4

	#revert Pear patch
	rm ${D}/usr/lib/php/PEAR/Registry.php
	#should this possibly result to the SAME original value it was ? (\$pear_install_dir)
	cat ${S}/pear/PEAR/Registry.old | sed -e 's:${PORTAGE_TMPDIR}/${PF}::' > ${D}/usr/lib/php/PEAR/Registry.php


	# Support for Java extension
	# 1. install php_java.jar file into ${EXT_DIR}
	# 2. edit the php.ini file ready for installation
	# - stuart@gentoo.org
	local phpinisrc=php.ini-dist
	if [ "`use java`" ] ; then

		# we put these into /usr/lib so that they cannot conflict with
		# other versions of PHP (e.g. PHP 4 & PHP 5)

		insinto ${PHPEXTDIR}
		einfo "Installing JAR for PHP"
		doins ext/java/php_java.jar

		einfo "Installing Java test page"
		newins ext/java/except.php java-test.php

		JAVA_LIBRARY="`grep -- '-DJAVALIB' Makefile | sed -e 's,.\+-DJAVALIB=\"\([^"]*\)\".*$,\1,g;'| sort | uniq `"
		cat ${phpinisrc} | sed -e "s|;java.library .*$|java.library = ${JAVA_LIBRARY}|g" > php.ini-1
		cat php.ini-1 | sed -e "s|;java.class.path .*$|java.class.path = ${PHPEXTDIR}/php_java.jar|g" > php.ini-2
		cat php.ini-2 | sed -e "s|extension_dir .*$|extension_dir = ${PHPEXTDIR}|g" > php.ini-3
		cat php.ini-3 | sed -e "s|;extension=php_java.dll.*$|extension = java.so|g" > php.ini-4
		cat php.ini-4 | sed -e "s|;java.library.path .*$|java.library.path = ${PHPEXTDIR}|g" > php.ini-5
		phpinisrc=php.ini-5
		dosym ${PHPEXTDIR}/java.so ${PHPEXTDIR}/libphp_java.so
		#( cd ${D} ; ln -snf ${PHPEXTDIR}/java.so ${D}/${PHPEXTDIR}/libphp_java.so )
	fi

	# A lot of ini file funkiness
	insinto ${PHPINIDIRECTORY}
	newins ${phpinisrc} ${PHPINIFILENAME}
	dodir /etc/php4
	[ "${PHPMAJORVER}" -eq 4 ] && dosym ${PHPINIDIRECTORY}/${PHPINIFILENAME} /etc/php4/${PHPINIFILENAME}
}

php_pkg_preinst() {
	einfo "Preserving old php.ini if needed"
	mkdir -p ${PHPINIDIRECTORY}
	[ -e /etc/php4/php.ini ] && [ -f /etc/php4/php.ini ] && mv -f /etc/php4/php.ini ${PHPINIDIRECTORY}/${PHPINIFILENAME}
}

php_pkg_postinst() {
	einfo "The INI file for this build is ${PHPINIDIRECTORY}"
}
