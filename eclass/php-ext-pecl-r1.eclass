# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-ext-pecl-r1.eclass,v 1.2 2005/10/31 14:08:42 chtekk Exp $
#
# Author: Tal Peer <coredumb@gentoo.org>
#
# This eclass should be used by all dev-php/PECL-* ebuilds, as a uniform way of installing PECL extensions.
# For more information about PECL, see: http://pecl.php.net

[ -z "${PHP_EXT_PECL_PKG}" ] && PHP_EXT_PECL_PKG=${PN/pecl-/}
PECL_PKG=${PHP_EXT_PECL_PKG}
PECL_PKG_V=${PECL_PKG}-${PV}

[ -z "${PHP_EXT_NAME}" ] && PHP_EXT_NAME=${PECL_PKG}

inherit php-ext-source-r1

EXPORT_FUNCTIONS src_compile src_install

# ---begin ebuild configurable settings

# Needs to be set if the filename is other than the package name
if [ -n "${PHP_EXT_PECL_FILENAME}" ]; then
	FILENAME="${PHP_EXT_PECL_FILENAME}-${PV}.tgz"
else
	FILENAME="${PECL_PKG_V}.tgz"
fi

# ---end ebuild configurable settings

SRC_URI="http://pecl.php.net/get/${FILENAME}"
HOMEPAGE="http://pecl.php.net/${PECL_PKG}"

S="${WORKDIR}/${PECL_PKG_V}"

php-ext-pecl-r1_src_compile() {
	has_php
	php-ext-source-r1_src_compile
}

php-ext-pecl-r1_src_install() {
	has_php
	php-ext-source-r1_src_install

	# Those two are always present
	dodoc-php "${WORKDIR}/package.xml" CREDITS
}
