# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-common-r1.eclass,v 1.7 2006/04/18 12:21:14 chtekk Exp $

# ########################################################################
#
# eclass/php-common-r1.eclass
#				Contains common functions which are shared between the
#				PHP4 and PHP5 packages
#
#				USE THIS ECLASS FOR THE "CONSOLIDATED" PACKAGES
#
#				Based on robbat2's work on the php4 sapi eclass
#				Based on stuart's work on the php5 sapi eclass
#
# Maintained by the PHP Herd <php-bugs@gentoo.org>
#
# ########################################################################

# ########################################################################
# CFLAG SANITY
# ########################################################################

php_check_cflags() {
	# Filter the following from C[XX]FLAGS regardless, as apache won't be
	# supporting LFS until 2.2 is released and in the tree. Fixes bug #24373.
	filter-flags "-D_FILE_OFFSET_BITS=64"
	filter-flags "-D_FILE_OFFSET_BITS=32"
	filter-flags "-D_LARGEFILE_SOURCE=1"
	filter-flags "-D_LARGEFILE_SOURCE"

	# Fixes bug #14067.
	# Changed order to run it in reverse for bug #32022 and #12021.
	replace-flags "-march=k6-3" "-march=i586"
	replace-flags "-march=k6-2" "-march=i586"
	replace-flags "-march=k6" "-march=i586"
}

# ########################################################################
# IMAP SUPPORT
# ########################################################################

php_check_imap() {
	if ! useq "imap" && ! phpconfutils_usecheck "imap" ; then
		return
	fi

	if useq "ssl" || phpconfutils_usecheck "ssl" ; then
		if ! built_with_use virtual/imap-c-client ssl ; then
			eerror
			eerror "IMAP with SSL requested, but your IMAP C-Client libraries are built without SSL!"
			eerror
			die "Please recompile the IMAP C-Client libraries with SSL support enabled"
		fi
	else
		if built_with_use virtual/imap-c-client ssl ; then
			eerror
			eerror "IMAP without SSL requested, but your IMAP C-Client libraries are built with SSL!"
			eerror
			die "Please recompile the IMAP C-Client libraries with SSL support disabled"
		fi
	fi
}

# ########################################################################
# JAVA EXTENSION SUPPORT
#
# The bundled java extension is unique to PHP4 at the time of writing, but
# there is now the PHP-Java-Bridge that works under both PHP4 and PHP5.
# ########################################################################

php_check_java() {
	if ! useq "java-internal" && ! phpconfutils_usecheck "java-internal" ; then
		return
	fi

	JDKHOME="`java-config --jdk-home`"
	NOJDKERROR="You need to use the 'java-config' utility to set your JVM to a JDK!"
	if [[ -z "${JDKHOME}" ]] || [[ ! -d "${JDKHOME}" ]] ; then
		eerror "${NOJDKERROR}"
		die "${NOJDKERROR}"
	fi

	# stuart@gentoo.org - 2003/05/18
	# Kaffe JVM is not a drop-in replacement for the Sun JDK at this time
	if echo ${JDKHOME} | grep kaffe > /dev/null 2>&1 ; then
		eerror
		eerror "PHP will not build using the Kaffe Java Virtual Machine."
		eerror "Please change your JVM to either Blackdown or Sun's."
		eerror
		eerror "To build PHP without Java support, please re-run this emerge"
		eerror "and place the line:"
		eerror "  USE='-java-internal'"
		eerror "in front of your emerge command, for example:"
		eerror "  USE='-java-internal' emerge =dev-lang/php-4*"
		eerror
		eerror "or edit your USE flags in /etc/make.conf."
		die "Kaffe JVM not supported"
	fi

	JDKVER=$(java-config --java-version 2>&1 | awk '/^java version/ { print $3 }' | xargs )
	einfo "Active JDK version: ${JDKVER}"
	case "${JDKVER}" in
		1.4.*) ;;
		1.5.*) ewarn "Java 1.5 is NOT supported at this time, and might not work." ;;
		*) eerror "A Java 1.4 JDK is recommended for Java support in PHP." ; die ;;
	esac
}

php_install_java() {
	if ! useq "java-internal" && ! phpconfutils_usecheck "java-internal" ; then
		return
	fi

	# We put these into /usr/lib so that they cannot conflict with
	# other versions of PHP (e.g. PHP 4 & PHP 5)
	insinto "${PHPEXTDIR}"
	einfo "Installing JAR for PHP"
	doins "ext/java/php_java.jar"

	einfo "Installing Java test page"
	newins "ext/java/except.php" "java-test.php"

	einfo "Installing Java extension for PHP"
	doins "modules/java.so"

	dosym "${PHPEXTDIR}/java.so" "${PHPEXTDIR}/libphp_java.so"
}

php_install_java_inifile() {
	if ! useq "java-internal" && ! phpconfutils_usecheck "java-internal" ; then
		return
	fi

	JAVA_LIBRARY="`grep -- '-DJAVALIB' Makefile | sed -e 's,.\+-DJAVALIB=\"\([^"]*\)\".*$,\1,g;' | sort -u`"

	echo "extension = java.so" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"
	echo "java.library = ${JAVA_LIBRARY}" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"
	echo "java.class.path = ${PHPEXTDIR}/php_java.jar" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"
	echo "java.library.path = ${PHPEXTDIR}" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"

	dosym "${PHP_EXT_INI_DIR}/java.ini" "${PHP_EXT_INI_DIR_ACTIVE}/java.ini"
}

# ########################################################################
# MTA SUPPORT
# ########################################################################

php_check_mta() {
	if ! [[ -x "${ROOT}/usr/sbin/sendmail" ]] ; then
		ewarn
		ewarn "You need a virtual/mta that provides a sendmail compatible binary!"
		ewarn "All major MTAs provide this, and it's usually some symlink created"
		ewarn "as '${ROOT}/usr/sbin/sendmail*'. You should also be able to use other"
		ewarn "MTAs directly, but you'll have to edit the sendmail_path directive"
		ewarn "in your php.ini for this to work."
		ewarn
	fi
}

# ########################################################################
# ORACLE SUPPORT
# ########################################################################

php_check_oracle_all() {
	if useq "oci8" && [[ -z "${ORACLE_HOME}" ]] ; then
		eerror
		eerror "You must have the ORACLE_HOME variable set in your environment to"
		eerror "compile the Oracle extension."
		eerror
		die "Oracle configuration incorrect; user error"
	fi

	if useq "oci8" || useq "oracle7" ; then
		if has_version 'dev-db/oracle-instantclient-basic' ; then
			ewarn
			ewarn "Please ensure you have a full install of the Oracle client."
			ewarn "'dev-db/oracle-instantclient-basic' is NOT sufficient."
			ewarn "Please enable the 'oci8-instant-client' USE flag instead, if you"
			ewarn "want to use 'dev-db/oracle-instantclient-basic' as Oracle client."
			ewarn
		fi
	fi
}

php_check_oracle_8() {
	if useq "oci8" && [[ -z "${ORACLE_HOME}" ]] ; then
		eerror
		eerror "You must have the ORACLE_HOME variable set in your environment to"
		eerror "compile the Oracle extension."
		eerror
		die "Oracle configuration incorrect; user error"
	fi

	if useq "oci8" ; then
		if has_version 'dev-db/oracle-instantclient-basic' ; then
			ewarn
			ewarn "Please ensure you have a full install of the Oracle client."
			ewarn "'dev-db/oracle-instantclient-basic' is NOT sufficient."
			ewarn "Please enable the 'oci8-instant-client' USE flag instead, if you"
			ewarn "want to use 'dev-db/oracle-instantclient-basic' as Oracle client."
			ewarn
		fi
	fi
}

# ########################################################################
# POSTGRESQL SUPPORT
# ########################################################################

php_check_pgsql() {
	if useq "postgres" \
	&& useq "apache2" && useq "threads" \
	&& has_version ">=dev-db/libpq-8.1.3-r1" \
	&& ! built_with_use ">=dev-db/libpq-8.1.3-r1" "threads" ; then
		eerror
		eerror "You must build dev-db/libpq with the 'threads' USE flag"
		eerror "turned on if you want to build PHP with threads support!"
		eerror
		die "Rebuild dev-db/libpq with 'threads' USE flag enabled"
	fi
}

# ########################################################################
# END OF ECLASS
# ########################################################################
