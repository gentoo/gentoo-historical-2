# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/mod_php/mod_php-5.0.3-r2.ebuild,v 1.1 2005/03/13 22:19:13 stuart Exp $

IUSE="${IUSE} apache2"

# this duplicates the code from depend.apache.eclass, but it's the
# only way to do this here

if useq apache2 ; then
	APACHE_VERSION=2
else
	APACHE_VERSION=1
fi

KEYWORDS="~x86 ~amd64"
PROVIDE="virtual/httpd-php-${PV}"

SLOT="${APACHE_VERSION}"

PHPSAPI="apache${APACHE_VERSION}"
MY_P="php-${PV}"

# BIG FAT WARNING!
# the php eclass requires the PHPSAPI setting!
inherit eutils php5-sapi-r1 apache-module

need_apache

DESCRIPTION="Apache module for PHP 5"

pkg_setup() {

	# the list of safe MPM's may need revising
	if ! useq threads ; then
		APACHE2_SAFE_MPMS="prefork"
	else
		APACHE2_SAFE_MPMS="event metuxmpm peruser worker threadpool"
	fi

	apache-module_pkg_setup
	php5-sapi_pkg_setup
}

src_unpack() {
	php5-sapi_src_unpack

	# if we're not using threads, we need to force them to be switched
	# off by patching php's configure script
	cd ${S}
	if ! useq threads ; then
		epatch ${FILESDIR}/php5-prefork.patch || die "Unable to patch for prefork support"
		einfo "Rebuilding configure script"
		WANT_AUTOCONF=2.5 \
		autoconf -W no-cross || die "Unable to regenerate configure script"
	fi
}

src_compile() {
	if [ "${APACHE_VERSION}" = "2" ]; then
			if useq threads ; then
				my_conf="${my_conf} --enable-experimental-zts"
				ewarn "Enabling ZTS for Apache2 MPM"
			fi
	fi

	my_conf="${my_conf} --with-apxs${USE_APACHE2}=/usr/sbin/apxs${USE_APACHE2}"

	php5-sapi_src_compile
}

src_install() {
	PHP_INSTALLTARGETS="install"
	php5-sapi_src_install

	if [ -n "${USE_APACHE2}" ] ; then
		einfo "Installing a Apache2 config for PHP (70_mod_php5.conf)"
		insinto ${APACHE_MODULES_CONFDIR}
		doins "${FILESDIR}/5.0.2-r1/70_mod_php5.conf"
	else
		einfo "Installing a Apache config for PHP (mod_php5.conf)"
		insinto ${APACHE_MODULES_CONFDIR}
		doins ${FILESDIR}/mod_php5.conf
	fi
}
