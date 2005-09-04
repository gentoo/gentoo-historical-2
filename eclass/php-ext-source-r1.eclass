# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-ext-source-r1.eclass,v 1.1 2005/09/04 10:54:53 stuart Exp $
#
# Author: Tal Peer <coredumb@gentoo.org>
# Author: Stuart Herbert <stuart@gentoo.org>
#
# The php-ext-source eclass provides a unified interface for compiling and
# installing standalone PHP extensions ('modules') from source code
#
# To use this eclass, you must add the following to your ebuild:
#
# inherit php-ext-source-r1

inherit php-ext-base-r1

EXPORT_FUNCTIONS src_compile src_install

# ---begin ebuild configurable settings

# Wether or not to add a line in the php.ini for the extension
# (defaults to "yes" and shouldn't be changed in most cases)
[ -z "${PHP_EXT_INI}" ] && PHP_EXT_INI="yes"

# ---end ebuild configurable settings

DEPEND="${DEPEND}
		>=sys-devel/m4-1.4
		>=sys-devel/libtool-1.4.3"

php-ext-source-r1_src_compile() {
	# pull in the PHP settings
	has_php
	my_conf="${my_conf} --prefix=${PHPPREFIX} --with-php-config=${PHPCONFIG}"
	addpredict /usr/share/snmp/mibs/.index
	#phpize creates configure out of config.m4
	export WANT_AUTOMAKE=1.6
	${PHPIZE}
	./configure ${my_conf} || die "Unable to configure code to compile"
	emake || die "Unable to make code"
}

php-ext-source-r1_src_install() {
	has_php
	addpredict /usr/share/snmp/mibs/.index
	chmod +x build/shtool
	insinto ${EXT_DIR}
	doins modules/${PHP_EXT_NAME}.so
	php-ext-base-r1_src_install
}
